#!/bin/bash
# ==========================================================
#  Reparador automático do driver NVIDIA (sem reboot)
#  Autor: Leonardo Takashi Teramatsu com ajuda, claro, do GPT-5
#  Uso: sudo ./reparar_nvidia.sh
# ==========================================================

LOG="/tmp/reparo_nvidia_$(date +%F_%H-%M-%S).log"
echo "=== Reparo Automático NVIDIA ($(date)) ===" | tee "$LOG"
KERNEL=$(uname -r)
echo "Kernel atual: $KERNEL" | tee -a "$LOG"
echo

# ---------- FUNÇÃO AUXILIAR ----------
log() { echo -e "$1" | tee -a "$LOG"; }

# ---------- 1️⃣ DETECTAR GPU ----------
if ! lspci | grep -qi nvidia; then
    log "[❌] Nenhuma GPU NVIDIA detectada pelo lspci."
    log "     Verifique se a placa está fisicamente conectada."
    exit 1
else
    lspci | grep -i nvidia | tee -a "$LOG"
    echo
fi

# ---------- 2️⃣ VERIFICAR CONFLITO COM NOUVEAU ----------
if lsmod | grep -q nouveau; then
    log "[⚠️] O módulo 'nouveau' está carregado e conflita com o driver proprietário."
    log "→ Removendo 'nouveau' e aplicando blacklist..."
    sudo modprobe -r nouveau 2>/dev/null
    echo "blacklist nouveau" | sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null
    sudo update-initramfs -u >/dev/null 2>&1
    log "[✅] 'nouveau' removido e bloqueado para futuros boots."
else
    log "[✅] Nenhum conflito com 'nouveau' detectado."
fi
echo

# ---------- 3️⃣ VERIFICAR EXISTÊNCIA DO MÓDULO NVIDIA ----------
if ! modinfo nvidia &>/dev/null; then
    log "[⚠️] Módulo 'nvidia' não encontrado no sistema."
    log "→ Tentando reinstalar o driver NVIDIA apropriado..."
    if command -v apt &>/dev/null; then
        sudo apt update -y && sudo apt install -y nvidia-driver-550 >>"$LOG" 2>&1
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y akmod-nvidia >>"$LOG" 2>&1
    fi
else
    log "[✅] Módulo 'nvidia' encontrado no sistema."
fi
echo

# ---------- 4️⃣ VERIFICAR SE O MÓDULO ESTÁ CARREGADO ----------
if lsmod | grep -q "^nvidia"; then
    log "[✅] Módulo NVIDIA já está carregado."
else
    log "[⚠️] Módulo não carregado — tentando carregar manualmente..."
    sudo modprobe nvidia 2>>"$LOG" && log "[✅] Módulo carregado." || log "[❌] Falha ao carregar o módulo NVIDIA."
fi
echo

# ---------- 5️⃣ REINICIAR SERVIÇOS NVIDIA ----------
if systemctl list-unit-files | grep -q nvidia-persistenced.service; then
    log "[🔁] Reiniciando serviço nvidia-persistenced..."
    sudo systemctl restart nvidia-persistenced
    sudo systemctl enable nvidia-persistenced >>"$LOG" 2>&1
    log "[✅] Serviço nvidia-persistenced ativo."
else
    log "[ℹ️] Serviço nvidia-persistenced não encontrado (possível instalação minimalista)."
fi
echo

# ---------- 6️⃣ VERIFICAR DKMS ----------
if command -v dkms &>/dev/null; then
    log "[🔍] Verificando status DKMS..."
    dkms status | grep nvidia | tee -a "$LOG"
    if dkms status | grep -q "nvidia.*built"; then
        log "[⚠️] Driver construído, mas não instalado — corrigindo..."
        NV_VER=$(dkms status | grep nvidia | head -n1 | awk -F, '{print $2}' | xargs)
        sudo dkms install -m nvidia -v "$NV_VER" >>"$LOG" 2>&1
        log "[✅] Módulo DKMS NVIDIA instalado para o kernel atual."
    fi
else
    log "[ℹ️] DKMS não instalado — pulando esta etapa."
fi
echo

# ---------- 7️⃣ VERIFICAR SECURE BOOT ----------
if command -v mokutil &>/dev/null; then
    SB_STATE=$(mokutil --sb-state 2>/dev/null | grep -i "SecureBoot" | awk '{print $2}')
    log "Secure Boot: $SB_STATE"
    if [[ "$SB_STATE" == "enabled" ]]; then
        SIGNER=$(modinfo nvidia | grep signer | awk -F': ' '{print $2}')
        if [ -z "$SIGNER" ]; then
            log "[⚠️] Secure Boot ativo e módulo NVIDIA não assinado."
            log "     → Você pode desativar o Secure Boot na BIOS ou assinar manualmente:"
            log "       sudo kmodsign sha512 MOK.priv MOK.der /lib/modules/$KERNEL/updates/dkms/nvidia.ko"
        else
            log "[✅] Módulo assinado por: $SIGNER"
        fi
    fi
else
    log "[ℹ️] mokutil não encontrado — não foi possível verificar Secure Boot."
fi
echo

# ---------- 8️⃣ REGERAR DEPENDÊNCIAS E RECARREGAR ----------
log "[🔧] Regenerando dependências do kernel..."
sudo depmod -a
log "[🔁] Recarregando stack NVIDIA..."
sudo modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia 2>/dev/null
sudo modprobe nvidia 2>>"$LOG" && log "[✅] Stack recarregada com sucesso." || log "[❌] Falha ao recarregar stack NVIDIA."
echo

# ---------- 9️⃣ TESTAR NVIDIA-SMI ----------
log "[🧪] Testando comunicação com a GPU..."
if nvidia-smi &>/dev/null; then
    nvidia-smi | tee -a "$LOG"
    log "[✅] Comunicação com driver NVIDIA restaurada com sucesso!"
else
    log "[❌] Ainda sem comunicação com o driver."
    log "     → Possíveis causas:"
    log "       - Kernel incompatível com versão do driver"
    log "       - Secure Boot bloqueando módulo"
    log "       - GPU não alocada ao sistema (ex: Virtual Machine)"
fi
echo

# ---------- 🔚 FINALIZAÇÃO ----------
log "=== Processo de reparo concluído ==="
log "→ Relatório salvo em: $LOG"
