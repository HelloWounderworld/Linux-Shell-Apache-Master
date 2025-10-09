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