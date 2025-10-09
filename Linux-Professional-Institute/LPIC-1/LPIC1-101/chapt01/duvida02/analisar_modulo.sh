#!/bin/bash
# ==========================================================
#  Diagnóstico avançado de módulos de kernel Linux
#  Autor: Leonardo Takashi Teramatsu com ajuda, claro, do GPT-5
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
