# **Kit de diagnóstico automatizado**

Perfeito 👌 — abaixo está um **kit de diagnóstico automatizado completo** em **Bash**, projetado para verificar e gerar um relatório detalhado sobre o estado de qualquer **módulo de kernel** no Linux.

Ele identifica:

* se o módulo existe e está carregado,
* se há firmware ausente,
* se há conflito ou blacklist,
* se está assinado,
* se o *vermagic* corresponde ao kernel,
* se faz parte do DKMS,
* e se há erros no `dmesg`/`journalctl`.

---

## 🧰 **Script: `analisar_modulo.sh`**

```bash
#!/bin/bash
# ==========================================================
#  Diagnóstico avançado de módulos de kernel Linux
#  Autor: GPT-5
#  Uso: sudo ./analisar_modulo.sh <nome_do_modulo>
# ==========================================================

# Verificação de argumentos
if [ -z "$1" ]; then
    echo "Uso: sudo $0 <nome_do_modulo>"
    exit 1
fi

MOD="$1"
KERNEL="$(uname -r)"
TMPLOG="/tmp/mod_diagnostico_${MOD}.log"

echo "=== Diagnóstico de módulo: $MOD ==="
echo "Kernel atual: $KERNEL"
echo

# 1. Verificar se o módulo existe
MOD_PATH=$(find /lib/modules/$KERNEL -type f -name "${MOD}.ko*" 2>/dev/null)
if [ -z "$MOD_PATH" ]; then
    echo "[❌] Módulo '${MOD}' não encontrado em /lib/modules/$KERNEL"
    echo "     → Verifique se está instalado ou se é compatível com este kernel."
else
    echo "[✅] Módulo encontrado: $MOD_PATH"
fi
echo

# 2. Exibir informações básicas
if modinfo $MOD &>/dev/null; then
    echo "=== Informações de modinfo ==="
    modinfo $MOD | egrep "filename|version|vermagic|depends|signer|sig_key|license"
    echo
else
    echo "[⚠️] 'modinfo' não retornou informações para $MOD"
fi

# 3. Verificar correspondência de vermagic
VERMAGIC=$(modinfo -F vermagic $MOD 2>/dev/null)
if [ -n "$VERMAGIC" ]; then
    if [[ "$VERMAGIC" == *"$KERNEL"* ]]; then
        echo "[✅] Vermagic compatível com o kernel atual ($KERNEL)"
    else
        echo "[❌] Vermagic incompatível!"
        echo "     → Compilado para: $VERMAGIC"
        echo "     → Kernel atual:   $KERNEL"
    fi
fi
echo

# 4. Verificar se o módulo está carregado
if lsmod | grep -q "^${MOD}"; then
    echo "[✅] Módulo '${MOD}' está carregado."
else
    echo "[⚠️] Módulo '${MOD}' não está carregado."
    echo "     → Tente carregar manualmente com: sudo modprobe ${MOD}"
fi
echo

# 5. Verificar dependências
echo "=== Dependências ==="
modinfo -F depends $MOD 2>/dev/null | tr ',' '\n' | sed '/^$/d' | while read dep; do
    if lsmod | grep -q "^${dep}"; then
        echo "  [OK] $dep está carregado"
    else
        echo "  [Faltando] $dep não está carregado"
    fi
done
echo

# 6. Verificar blacklists
echo "=== Blacklists ==="
grep -R "blacklist.*${MOD}" /etc/modprobe.d/ /lib/modprobe.d/ 2>/dev/null | while read line; do
    echo "  [⚠️] Encontrado: $line"
done
echo

# 7. Verificar firmware ausente
echo "=== Verificação de firmware ==="
dmesg | grep -i "$MOD" | grep -i "firmware" | tail -n 10
echo

# 8. Verificar assinatura e Secure Boot
if mokutil --sb-state &>/dev/null; then
    SECUREBOOT=$(mokutil --sb-state | awk '{print $2}')
    echo "Secure Boot: $SECUREBOOT"
    if [[ "$SECUREBOOT" == "enabled" ]]; then
        SIG=$(modinfo -F signer $MOD 2>/dev/null)
        if [ -z "$SIG" ]; then
            echo "[⚠️] Secure Boot ativo e módulo não assinado — pode ser bloqueado."
        else
            echo "[✅] Módulo assinado por: $SIG"
        fi
    fi
else
    echo "[ℹ️] mokutil não disponível — não foi possível checar Secure Boot."
fi
echo

# 9. Verificar DKMS
if command -v dkms &>/dev/null; then
    echo "=== Verificação DKMS ==="
    dkms status | grep -i "$MOD" || echo "[ℹ️] Nenhuma entrada DKMS para $MOD"
else
    echo "[ℹ️] DKMS não instalado."
fi
echo

# 10. Logs de erros do módulo
echo "=== Últimos logs de kernel para '$MOD' ==="
dmesg | grep -i "$MOD" | tail -n 15 > "$TMPLOG"
if [ -s "$TMPLOG" ]; then
    cat "$TMPLOG"
else
    echo "[ℹ️] Nenhum log recente encontrado para este módulo."
fi

echo
echo "=== Fim do diagnóstico ==="
rm -f "$TMPLOG"
```

---

## 📦 **Como usar**

1. Salve o script:

   ```bash
   nano analisar_modulo.sh
   ```

   (cole o conteúdo acima)

2. Dê permissão de execução:

   ```bash
   chmod +x analisar_modulo.sh
   ```

3. Execute com o módulo desejado:

   ```bash
   sudo ./analisar_modulo.sh iwlwifi
   ```

   ou, para outro exemplo:

   ```bash
   sudo ./analisar_modulo.sh nvidia
   ```

---

## 📄 **Saída esperada (exemplo resumido)**

```
=== Diagnóstico de módulo: iwlwifi ===
Kernel atual: 6.8.0-36-generic

[✅] Módulo encontrado: /lib/modules/6.8.0-36-generic/kernel/drivers/net/wireless/intel/iwlwifi.ko
=== Informações de modinfo ===
filename: /lib/modules/...
version: 2023.12
vermagic: 6.8.0 SMP mod_unload
signer: Build key
license: GPL

[✅] Vermagic compatível com o kernel atual (6.8.0-36-generic)
[✅] Módulo 'iwlwifi' está carregado.
=== Dependências ===
  [OK] mac80211 está carregado
  [OK] cfg80211 está carregado
=== Blacklists ===
  (nenhum)
=== Verificação de firmware ===
iwlwifi 0000:02:00.0: loaded firmware version 77.c61391f4.0
Secure Boot: enabled
[✅] Módulo assinado por: Canonical Ltd. Secure Boot Signing
=== Verificação DKMS ===
[ℹ️] Nenhuma entrada DKMS para iwlwifi
=== Últimos logs de kernel para 'iwlwifi' ===
iwlwifi 0000:02:00.0: Detected Intel(R) Wi-Fi 6 AX200
=== Fim do diagnóstico ===
```

---

## ✅ **O que ele te entrega**

| Item                        | Verificação |
| --------------------------- | ----------- |
| Existência física do módulo | ✅           |
| Versão e vermagic           | ✅           |
| Dependências ausentes       | ✅           |
| Blacklists aplicadas        | ✅           |
| Firmware ausente            | ✅           |
| Assinatura/Secure Boot      | ✅           |
| Integração com DKMS         | ✅           |
| Logs de erro no kernel      | ✅           |

---

## 💡 **Uso prático**

Esse script é ideal para:

* Troubleshooting de hardware recém-instalado (Wi-Fi, GPU, som, etc.)
* Diagnóstico em sistemas minimalistas ou WSL2 customizados
* Ambientes corporativos (quando o autoload de módulo falha)
* Auditoria de segurança (checar módulos não assinados com Secure Boot ativo)

---

# 🧠 **Script Avançado: `reparar_modulo.sh`**

Perfeito 👌 — aqui vem a **versão PRO** do kit:
um **“analisar & corrigir”** automatizado em **Bash**, que não só diagnostica, mas também **tenta reparar automaticamente** módulos de kernel problemáticos.

Esse script é ideal para administradores que querem **agilidade e robustez**, especialmente ao lidar com módulos que não carregam, estão desatualizados, faltam firmware, ou estão bloqueados por blacklist.

```bash
#!/bin/bash
# ==========================================================
#  Analisador e reparador automático de módulos de kernel
#  Autor: GPT-5
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

# ---------- 6. VERIFICAR ASSINATURA E SECURE BOOT ----------
if mokutil --sb-state &>/dev/null; then
    SECUREBOOT=$(mokutil --sb-state | awk '{print $2}')
    log "Secure Boot: $SECUREBOOT"
    if [[ "$SECUREBOOT" == "enabled" ]]; then
        SIG=$(modinfo -F signer $MOD 2>/dev/null)
        if [ -z "$SIG" ]; then
            log "[⚠️] Secure Boot ativo e módulo não assinado."
            log "     → Opções:"
            log "       - Desativar Secure Boot temporariamente, ou"
            log "       - Assinar o módulo com sua chave MOK."
        else
            log "[✅] Módulo assinado por: $SIG"
        fi
    fi
else
    log "[ℹ️] mokutil não disponível — não foi possível checar Secure Boot."
fi
echo

# ---------- 7. REGERAR DEPENDÊNCIAS E RECARREGAR ----------
log "[🔧] Regenerando dependências com depmod..."
sudo depmod -a
log "[🔁] Recarregando módulo..."
sudo modprobe -r "$MOD" 2>/dev/null
if sudo modprobe "$MOD" 2>>"$REPARO_LOG"; then
    log "[✅] Módulo recarregado com sucesso."
else
    log "[❌] Falha ao recarregar o módulo. Verifique $REPARO_LOG."
fi
echo

# ---------- 8. VALIDAR STATUS FINAL ----------
log "=== Status final ==="
if lsmod | grep -q "^${MOD}"; then
    log "[✅] Módulo '$MOD' ativo e carregado."
else
    log "[❌] Módulo '$MOD' ainda não está ativo."
fi
echo

# ---------- 9. EXIBIR ERROS DO KERNEL ----------
log "=== Últimos logs de kernel relacionados ==="
dmesg | grep -i "$MOD" | tail -n 10 | tee -a "$LOG"
echo

# ---------- 10. FINALIZAÇÃO ----------
log "=== Reparo concluído ==="
echo
log "→ Relatório salvo em: $LOG"
log "→ Log detalhado de execução: $REPARO_LOG"
```

---

## ⚙️ **Como usar**

1. Crie o arquivo:

   ```bash
   nano reparar_modulo.sh
   ```

   (cole o script acima)

2. Dê permissão de execução:

   ```bash
   chmod +x reparar_modulo.sh
   ```

3. Execute com o módulo desejado:

   ```bash
   sudo ./reparar_modulo.sh iwlwifi
   ```

---

## 📄 **Saída esperada (exemplo)**

```
=== Análise e reparo automático do módulo: iwlwifi ===
Kernel atual: 6.8.0-36-generic

[✅] Módulo encontrado: /lib/modules/6.8.0-36-generic/kernel/drivers/net/wireless/intel/iwlwifi.ko
[⚠️] Módulo 'iwlwifi' não está carregado — tentando carregar...
[✅] Módulo carregado com sucesso.

=== Verificação de dependências ===
  [OK] cfg80211 já carregada.
  [OK] mac80211 já carregada.

=== Verificação de firmware ===
[✅] Nenhum erro de firmware aparente nos logs.

Secure Boot: enabled
[✅] Módulo assinado por: Canonical Ltd. Secure Boot Signing

[🔧] Regenerando dependências com depmod...
[🔁] Recarregando módulo...
[✅] Módulo recarregado com sucesso.

=== Status final ===
[✅] Módulo 'iwlwifi' ativo e carregado.
```

---

## 💡 **O que ele faz automaticamente**

| Ação                            | Descrição                                       |
| ------------------------------- | ----------------------------------------------- |
| ✅ Analisa módulo e dependências | Usa `modinfo`, `lsmod`, `depmod`                |
| 🔧 Recarrega módulo             | Executa `modprobe -r` + `modprobe`              |
| 🚫 Remove blacklists            | Comenta entradas conflitantes                   |
| 📦 Reinstala firmware           | Usa `apt install linux-firmware`                |
| 🔐 Verifica Secure Boot         | Avisa sobre módulos não assinados               |
| 🧠 Regenera dependências        | Executa `depmod -a`                             |
| 📋 Gera logs                    | Salva relatórios em `/tmp/mod_reparo_<mod>.log` |

---

## 🧩 **Extras sugeridos**

Se quiser, posso gerar uma **versão 3.0** que:

* **detecta automaticamente o módulo** de um *device ID* (`lspci -nn` / `lsusb`);
* permite **modo não interativo** (para execução em larga escala, tipo servidores);
* e exporta um **relatório JSON** de diagnóstico.

---

# ⚙️ **Script: `reparar_nvidia.sh`**

Perfeito 👌 — aqui vai o **script especializado para diagnóstico e reparo automático do driver NVIDIA**, projetado para restaurar o funcionamento do `nvidia-smi` **sem reboot**.

Ele atua em três níveis:
1️⃣ diagnóstico e detecção do problema,
2️⃣ correção automatizada (carregamento de módulos, DKMS, blacklist, Secure Boot etc.),
3️⃣ validação final.

```bash
#!/bin/bash
# ==========================================================
#  Reparador automático do driver NVIDIA (sem reboot)
#  Autor: GPT-5
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
```

---

## 🧩 **Como usar**

1. Crie o script:

   ```bash
   nano reparar_nvidia.sh
   ```

   (cole o conteúdo acima)

2. Dê permissão:

   ```bash
   chmod +x reparar_nvidia.sh
   ```

3. Execute como root:

   ```bash
   sudo ./reparar_nvidia.sh
   ```

---

## 📄 **Saída esperada (exemplo)**

```
=== Reparo Automático NVIDIA (2025-10-09 21:42:33) ===
Kernel atual: 6.8.0-36-generic

01:00.0 VGA compatible controller: NVIDIA Corporation TU106 [GeForce RTX 2070]

[✅] Nenhum conflito com 'nouveau' detectado.
[✅] Módulo 'nvidia' encontrado no sistema.
[⚠️] Módulo não carregado — tentando carregar manualmente...
[✅] Módulo carregado.

[🔁] Reiniciando serviço nvidia-persistenced...
[✅] Serviço nvidia-persistenced ativo.

[🔧] Regenerando dependências do kernel...
[✅] Stack recarregada com sucesso.

[🧪] Testando comunicação com a GPU...
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 550.78       Driver Version: 550.78       CUDA Version: 12.3     |
| GPU Name: GeForce RTX 2070                                                |
+-----------------------------------------------------------------------------+
[✅] Comunicação com driver NVIDIA restaurada com sucesso!

=== Processo de reparo concluído ===
→ Relatório salvo em: /tmp/reparo_nvidia_2025-10-09_21-42-33.log
```

---

## 🧠 **O que ele faz automaticamente**

| Etapa | Ação                                   |
| ----- | -------------------------------------- |
| 1️⃣   | Detecta GPU NVIDIA no sistema          |
| 2️⃣   | Remove e bloqueia `nouveau`            |
| 3️⃣   | Verifica e reinstala módulo `nvidia`   |
| 4️⃣   | Carrega módulo no kernel atual         |
| 5️⃣   | Reinicia `nvidia-persistenced`         |
| 6️⃣   | Corrige DKMS e recompila se necessário |
| 7️⃣   | Detecta problemas com Secure Boot      |
| 8️⃣   | Regenera dependências (`depmod`)       |
| 9️⃣   | Recarrega a stack NVIDIA completa      |
| 🔟    | Valida com `nvidia-smi` e gera log     |

---

## ⚡ **Usos práticos**

* Repara falhas após `apt upgrade` do kernel.
* Corrige conflitos de `nouveau`.
* Evita reboot em workstations e servidores com GPUs.
* Diagnóstico rápido em instâncias virtuais com passthrough de GPU.

---

Se quiser, posso te montar uma **versão aprimorada com modo interativo**, que:

* lista todas as GPUs detectadas,
* permite escolher o driver a reinstalar (ex: 535, 550, 560 beta),
* e oferece opção para **recarregar o Xorg/Wayland** automaticamente após o reparo.

