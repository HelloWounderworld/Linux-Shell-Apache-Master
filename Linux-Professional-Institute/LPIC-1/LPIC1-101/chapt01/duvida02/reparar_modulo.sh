#!/bin/bash
# ==========================================================
#  Analisador e reparador automático de módulos de kernel
#  Autor: Leonardo Takashi Teramatsu com ajuda, claro, do GPT-5
#  Uso: sudo ./reparar_modulo.sh <nome_do_modulo>
# ==========================================================

# ---------- CONFIGURAÇÕES INICIAIS ----------
MOD="$1"
KERNEL="$(uname -r)"
LOG="/tmp/mod_reparo_${MOD}.log"
REPARO_LOG="/tmp/mod_reparo_exec_${MOD}.log"
FIRMWARE_PKGS=("linux-firmware" "firmware-linux" "firmware-linux-nonfree")

if [ -z "$MOD" ]; then
    echo "Uso: sudo $0 <nome_do_modulo>"
    exit 1
fi

echo "=== Análise e reparo automático do módulo: $MOD ==="
echo "Kernel atual: $KERNEL"
echo

# ---------- FUNÇÃO AUXILIAR ----------
log() { echo -e "$1" | tee -a "$LOG"; }

# ---------- 1. VERIFICAR EXISTÊNCIA ----------
MOD_PATH=$(find /lib/modules/$KERNEL -type f -name "${MOD}.ko*" 2>/dev/null)
if [ -z "$MOD_PATH" ]; then
    log "[❌] Módulo '${MOD}' não encontrado em /lib/modules/$KERNEL."
    log "     Tentando localizar no sistema..."
    MOD_PATH=$(find / -type f -name "${MOD}.ko*" 2>/dev/null | head -n 1)
    if [ -z "$MOD_PATH" ]; then
        log "     → Não encontrado em lugar algum. Necessário reinstalar/compilar."
        exit 1
    fi
fi
log "[✅] Módulo encontrado: $MOD_PATH"
echo

# ---------- 2. VERIFICAR SE ESTÁ CARREGADO ----------
if lsmod | grep -q "^${MOD}"; then
    log "[✅] O módulo '${MOD}' já está carregado."
else
    log "[⚠️] Módulo '${MOD}' não está carregado — tentando carregar..."
    if sudo modprobe "$MOD" 2>>"$REPARO_LOG"; then
        log "[✅] Módulo carregado com sucesso."
    else
        log "[❌] Falha ao carregar o módulo via modprobe."
        log "Verifique o log em $REPARO_LOG."
    fi
fi
echo

# ---------- 3. VERIFICAR DEPENDÊNCIAS ----------
log "=== Verificação de dependências ==="
for dep in $(modinfo -F depends "$MOD" 2>/dev/null | tr ',' ' '); do
    if [ -z "$dep" ]; then
        continue
    fi
    if lsmod | grep -q "^${dep}"; then
        log "  [OK] Dependência '${dep}' já carregada."
    else
        log "  [Faltando] Dependência '${dep}' — tentando carregar..."
        sudo modprobe "$dep" 2>>"$REPARO_LOG" && log "  [✅] '${dep}' carregada."
    fi
done
echo

# ---------- 4. VERIFICAR BLACKLIST ----------
log "=== Verificação de blacklist ==="
BLACKLIST_LINES=$(grep -R "blacklist.*${MOD}" /etc/modprobe.d/ /lib/modprobe.d/ 2>/dev/null)
if [ -n "$BLACKLIST_LINES" ]; then
    log "[⚠️] Blacklist encontrada:"
    echo "$BLACKLIST_LINES" | tee -a "$LOG"
    log "→ Removendo temporariamente blacklists..."
    sudo sed -i "/blacklist.*${MOD}/ s/^/#/" /etc/modprobe.d/*.conf 2>/dev/null
    sudo sed -i "/blacklist.*${MOD}/ s/^/#/" /lib/modprobe.d/*.conf 2>/dev/null
    log "[✅] Blacklists comentadas."
else
    log "[✅] Nenhuma blacklist para '${MOD}'."
fi
echo

# ---------- 5. VERIFICAR FIRMWARE ----------
log "=== Verificação de firmware ==="
if dmesg | grep -i "$MOD" | grep -qi "firmware"; then
    log "[⚠️] Possível problema de firmware detectado. Tentando reinstalar..."
    for pkg in "${FIRMWARE_PKGS[@]}"; do
        if apt list --installed 2>/dev/null | grep -q "$pkg"; then
            log "  [OK] Pacote $pkg já instalado."
        else
            log "  [🔧] Instalando pacote $pkg..."
            sudo apt install -y "$pkg" >>"$REPARO_LOG" 2>&1
        fi
    done
    log "[✅] Verificação de firmware concluída."
else
    log "[✅] Nenhum erro de firmware aparente nos logs."
fi
echo

# --
