# 📌 O que significa carregar e descarregar módulos do kernel

## 1. Kernel e módulos

* O **kernel Linux** é o núcleo do sistema operacional, que gerencia hardware, processos e recursos.
* Ele pode ser construído de duas formas:

  * **Monolítico fixo**: todos os drivers e funcionalidades já embutidos.
  * **Modular**: funcionalidades extras ficam em arquivos separados (`.ko` → *kernel objects*), que podem ser adicionados ou removidos em tempo de execução.

Esses arquivos separados são os **módulos do kernel** (por exemplo, driver de placa de rede, driver de sistema de arquivos, driver de USB).

---

## 2. Carregar um módulo

**Carregar um módulo** significa **inserir um objeto de kernel (.ko) na memória do kernel em execução**, tornando suas funcionalidades disponíveis imediatamente.

* Comando:

  ```bash
  insmod nome_do_modulo.ko
  # ou, mais comum:
  modprobe nome_do_modulo
  ```
* O `modprobe` é preferido porque **resolve dependências automaticamente** (se um módulo depende de outro, ele carrega junto).

Exemplo:

```bash
modprobe e1000e
```

→ Carrega o driver da Intel para algumas placas de rede Gigabit.

---

## 3. Descarregar um módulo

**Descarregar um módulo** significa **remover esse código da memória do kernel**, liberando recursos e tornando o dispositivo/funcionalidade indisponível.

* Comando:

  ```bash
  rmmod nome_do_modulo
  # ou
  modprobe -r nome_do_modulo
  ```
* Só é possível descarregar se:

  * O módulo não estiver em uso (sem processos ativos nem dependências de outros módulos).

Exemplo:

```bash
modprobe -r e1000e
```

→ Descarrega o driver de rede, desativando a interface correspondente.

---

# 📌 Utilidades práticas

1. **Gerenciamento dinâmico de hardware**

   * Permite ativar/desativar drivers sem precisar reinicializar o sistema.
   * Útil em ambientes de teste e desenvolvimento.

2. **Economia de recursos**

   * Módulos não usados podem ser descarregados, reduzindo consumo de memória no kernel.

3. **Diagnóstico e troubleshooting**

   * Se um driver apresenta problemas, você pode descarregá-lo e recarregá-lo para reestabelecer funcionamento.
   * Ex.: descarregar e recarregar o driver de uma placa Wi-Fi que parou de funcionar.

4. **Segurança**

   * Remover módulos desnecessários diminui a superfície de ataque.
   * Exemplo: se o sistema não usa USB, descarregar o módulo de USB pode evitar ataques de dispositivos maliciosos (*BadUSB*).

5. **Customização em tempo real**

   * Em servidores, sistemas embarcados ou VMs, você só mantém módulos estritamente necessários.

---

# 📌 Importância

* **Flexibilidade**: permite que o Linux rode em milhões de dispositivos diferentes sem precisar recompilar o kernel para cada caso.
* **Confiabilidade**: facilita corrigir falhas ou atualizar drivers sem reiniciar todo o sistema.
* **Manutenibilidade**: reduz a complexidade do kernel base, deixando funcionalidades opcionais como módulos externos.
* **Performance**: libera recursos quando módulos não são necessários.

---

# 📌 Resumindo em uma frase sólida

**Carregar um módulo de kernel é adicionar dinamicamente uma funcionalidade (como um driver) ao kernel em execução, e descarregar é removê-la, trazendo flexibilidade, economia de recursos, segurança e capacidade de manutenção em tempo real.**

---

# **Funcionamento dos drivers**

> 👉 Pergunta: Uma outra duvida que surgiu sobre o modulo kernel e os meios de inspecoes, sejam elas por meio de lspci, lsusb ou lsmod. Mesmo que o dispositivo ela tenha conseguido ser identificado pela maquina. Existem situacoes em que voce precisaria ativar, manualmente, o modulo kernel desse dispositivo para conseguir rodar o dispositivo?

Excelente pergunta — e sim, você captou um ponto técnico **real e fundamental** sobre o funcionamento dos drivers no Linux.

Vamos fechar isso com explicação **conceitual e prática**, sem brechas:
1️⃣ por que um dispositivo pode ser reconhecido (via *enumeration* PCI/USB) e mesmo assim não funcionar,
2️⃣ quando é preciso carregar manualmente o módulo de kernel,
3️⃣ como identificar essa necessidade e fazê-lo corretamente.

---

## 🔍 1. Entendendo as camadas envolvidas

Quando você conecta ou tem um dispositivo no sistema, três etapas independentes acontecem:

| Etapa                                        | Responsável                                | O que ocorre                                                                                                                              |
| -------------------------------------------- | ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Detecção física (enumeration)**         | BIOS/firmware + kernel (PCI/USB subsystem) | O barramento anuncia: “há um dispositivo neste endereço (vendor:device)”. Ele aparece em `lspci`, `lsusb`, etc.                           |
| **2. Associação (driver binding)**           | subsistema de *udev* e kernel modules      | O kernel procura se existe algum módulo capaz de atender aquele `vendor:device ID`. Se houver, ele o carrega automaticamente (auto-load). |
| **3. Inicialização funcional (driver init)** | módulo do kernel (driver)                  | O módulo inicializa o dispositivo, aloca buffers, inicializa IRQs, cria interfaces (`/dev/*`, `eth0`, `sda`, etc.).                       |

Portanto:
➡️ **Ver o dispositivo no `lspci`/`lsusb` significa apenas que o kernel viu o hardware.**
➡️ **Mas ele só “funciona” (gera interface de rede, monta disco, reconhece GPU, etc.) se o módulo do kernel correspondente estiver carregado.**

---

## ⚙️ 2. Situações em que o módulo *não* é carregado automaticamente

Mesmo que o dispositivo tenha sido identificado, há vários cenários em que o módulo precisa ser **carregado manualmente**:

1. **Driver não está incluso no kernel atual**

   * O kernel reconhece o hardware, mas não tem módulo correspondente (por versão antiga, kernel minimalista, ou driver não-livre).
   * Exemplo: GPU NVIDIA sem `nvidia.ko`; adaptador Wi-Fi Realtek sem módulo `rtl88XXau`.

2. **O módulo existe, mas não foi associado (binding não ocorreu)**

   * Pode ser por IDs de dispositivo diferentes (ex.: placa revisada com novo ID que o módulo ainda não conhece).
   * Pode ser forçado com:

     ```bash
     sudo modprobe nome_do_modulo
     echo "vendorID deviceID" | sudo tee /sys/bus/pci/drivers/nome_do_modulo/new_id
     ```

3. **Carregamento automático desativado / blacklisted**

   * Arquivo `/etc/modprobe.d/blacklist.conf` ou `/lib/modprobe.d/*` pode impedir o autoload.
   * Útil em troubleshooting (para evitar conflito de drivers), mas se bloqueado, só manual.

4. **Módulo requer firmware não encontrado**

   * Driver tenta subir mas precisa de um *firmware blob* em `/lib/firmware/`.
   * `dmesg` mostra algo como:

     ```
     firmware: failed to load iwlwifi-7265D-29.ucode (-2)
     ```
   * Só funcionará após instalar o pacote de firmware correspondente.

5. **Dependência de outro módulo**

   * Alguns módulos só sobem após outro estar ativo (por exemplo, `usb_storage` depende de `usbcore`).
   * Normalmente o `modprobe` resolve isso, mas se for carregado manualmente via `insmod`, dependências precisam ser resolvidas explicitamente.

6. **Compilação customizada ou kernel modularizado**

   * Em sistemas minimalistas, o administrador escolhe quais módulos subir manualmente para reduzir superfície de ataque ou footprint.

---

## 🧠 3. Como verificar se o módulo do dispositivo está ativo

### a) Identifique o hardware

```bash
lspci -nn
# ou
lsusb
```

### b) Veja o módulo associado

```bash
lspci -k
```

Saída típica:

```
02:00.0 Network controller: Intel Corporation Wi-Fi 6 AX200
        Subsystem: Intel Device 0084
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
```

Se “**Kernel driver in use**” estiver vazio, o driver não foi carregado.

---

## 🧩 4. Como carregar manualmente o módulo

```bash
sudo modprobe nome_do_modulo
```

ou, se o arquivo .ko estiver fora dos caminhos padrão:

```bash
sudo insmod /path/to/driver.ko
```

→ Use `modprobe` sempre que possível — ele resolve dependências automaticamente.

Para persistir o carregamento no boot:

```bash
echo nome_do_modulo | sudo tee -a /etc/modules-load.d/custom.conf
```

---

## 🧾 5. Como diagnosticar falhas de carregamento

Ferramentas úteis:

| Comando                  | Função                               |                                 |
| ------------------------ | ------------------------------------ | ------------------------------- |
| `dmesg                   | grep -i firmware`                    | Verifica erros de firmware      |
| `dmesg                   | grep -i nome_do_modulo`              | Logs de inicialização do módulo |
| `lsmod                   | grep nome_do_modulo`                 | Confirma se está carregado      |
| `modinfo nome_do_modulo` | Mostra dependências e IDs suportados |                                 |
| `journalctl -k -b`       | Logs do kernel do boot atual         |                                 |

---

## 📌 6. Conclusão (sem brecha)

> **Ver o dispositivo via `lspci` ou `lsusb` significa que o hardware foi detectado pelo barramento, mas não garante que o driver (módulo de kernel) correspondente esteja carregado e funcional.**
> Se o módulo não foi autocarregado — por falta, incompatibilidade, blacklist, dependência ou firmware ausente — é preciso carregá-lo manualmente com `modprobe`, e verificar logs do kernel (`dmesg`) para confirmar o sucesso da inicialização.

---

# **Roteiro técnico e completo para diagnóstico**

Perfeito — aqui vai um **roteiro técnico e completo** para diagnosticar dispositivos detectados pelo sistema, mas que ainda **não estão com o módulo de kernel ativo ou funcional**.

* dispositivos sem módulo carregado,
* firmware ausente,
* e comandos de correção (para modprobe e instalação de firmware).

O procedimento é compatível com **Ubuntu/Debian/Red Hat/Fedora/CentOS** e cobre tanto dispositivos **PCI** quanto **USB**.
A ideia é: detectar → identificar driver → verificar estado → corrigir.

---

## 🧭 **1. Descobrir os dispositivos detectados pelo barramento**

Comece inspecionando o hardware físico reconhecido pelo kernel.

```bash
## Dispositivos PCI (placas de rede, vídeo, som, etc.)
lspci -nn

## Dispositivos USB (câmeras, adaptadores Wi-Fi, etc.)
lsusb
```

O campo **`[vendor:device]`** será útil depois para identificar o driver correto.
Exemplo de saída:

```
02:00.0 Network controller [0280]: Intel Corporation Wi-Fi 6 AX200 [8086:2723]
```

---

## ⚙️ **2. Verificar se existe driver associado**

```bash
## Mostra qual driver (módulo) o kernel associou, se houver
lspci -k
```

Saída típica:

```
02:00.0 Network controller: Intel Corporation Wi-Fi 6 AX200
        Subsystem: Intel Device 0084
        Kernel driver in use: iwlwifi
        Kernel modules: iwlwifi
```

✅ Se **`Kernel driver in use`** estiver preenchido → o módulo foi carregado.
⚠️ Se estiver **vazio** → o módulo existe, mas não está carregado automaticamente.

---

## 🔎 **3. Localizar o módulo e suas informações**

Use `modinfo` para entender se o módulo existe e se suporta aquele hardware:

```bash
sudo modinfo iwlwifi
```

Ele mostrará:

* caminho do `.ko` (`/lib/modules/...`)
* versão do módulo
* dependências
* IDs de dispositivos suportados (`alias:` linhas)

Se o ID `[8086:2723]` **não aparecer** entre os alias, o módulo não reconhece o dispositivo — você pode precisar de um **kernel mais recente** ou driver externo.

---

## 🧩 **4. Verificar se o módulo está carregado**

```bash
lsmod | grep iwlwifi
```

Se não aparecer, ele não está ativo.

Carregue manualmente:

```bash
sudo modprobe iwlwifi
```

Confirme:

```bash
lsmod | grep iwlwifi
```

---

## 📡 **5. Detectar falhas de carregamento (logs do kernel)**

Logo após o `modprobe`, verifique mensagens de erro:

```bash
dmesg | tail -n 20
```

Erros comuns e seus significados:

| Mensagem                            | Significado          | Solução                                                                                       |
| ----------------------------------- | -------------------- | --------------------------------------------------------------------------------------------- |
| `firmware: failed to load ... (-2)` | Firmware ausente     | Instale o pacote `linux-firmware` (Ubuntu) ou `linux-firmware` / `iwlwifi-firmware` (Fedora). |
| `Unknown symbol in module`          | Dependência faltando | Use `modprobe` (não `insmod`) para resolver dependências.                                     |
| `Device not found`                  | Driver incorreto     | Tente módulo alternativo ou kernel mais novo.                                                 |

---

## 🧰 **6. Verificar se o módulo está sendo bloqueado**

Às vezes o autoload falha porque o módulo foi **blacklisted**:

```bash
grep -R "blacklist" /etc/modprobe.d/ /lib/modprobe.d/
```

Se aparecer algo como `blacklist iwlwifi`, comente a linha ou remova o arquivo:

```bash
sudo sed -i 's/^blacklist/# blacklist/' /etc/modprobe.d/blacklist.conf
```

Recarregue:

```bash
sudo modprobe -r iwlwifi
sudo modprobe iwlwifi
```

---

## 🔐 **7. Instalar firmwares ausentes**

O kernel pode reconhecer o driver, mas falhar ao carregar o **firmware binário** que o dispositivo precisa.

```bash
sudo apt install linux-firmware     # Debian/Ubuntu
# ou
sudo dnf install linux-firmware     # Fedora/RedHat
```

Verifique novamente:

```bash
dmesg | grep -i firmware
```

---

## 🧩 **8. Persistir o carregamento no boot**

Se o módulo só funcionar após `modprobe`, adicione-o à lista de carregamento:

```bash
echo iwlwifi | sudo tee -a /etc/modules-load.d/custom.conf
```

---

## 🧠 **9. Diagnóstico automático (com script)**

Crie um pequeno script de inspeção:

```bash
#!/bin/bash
echo "=== Dispositivos PCI sem driver ==="
lspci -k | awk '/^[0-9]/ {dev=$0} /Kernel driver in use/ {used=$NF} /Kernel modules/ {mod=$NF; if (used=="") print dev "\n -> Possível módulo: " mod "\n"}'

echo
echo "=== Módulos carregados ==="
lsmod | awk '{print $1}' | head -n 10

echo
echo "=== Erros recentes de firmware ==="
dmesg | grep -i firmware | tail -n 10
```

Salve como `check_drivers.sh`, dê permissão:

```bash
chmod +x check_drivers.sh
./check_drivers.sh
```

Ele mostrará rapidamente:

* quais dispositivos estão sem driver ativo,
* quais módulos são sugeridos,
* e possíveis falhas de firmware.

---

## ✅ **10. Conclusão (fechado)**

> Um dispositivo pode aparecer em `lspci`/`lsusb` apenas por estar fisicamente detectado.
> Para funcionar, o kernel precisa associar e carregar o módulo correto.
> Se não o fizer automaticamente, o administrador pode identificar, carregar manualmente, resolver dependências ou instalar firmware ausente — e persistir o módulo para o boot seguinte.

---

# **Debug avançado de módulos**

Perfeito 👌 — aqui vem a **parte avançada do diagnóstico de módulos de kernel**, voltada a cenários onde o driver **existe**, mas **não inicializa corretamente** (ou o kernel sequer tenta carregá-lo).

Essa parte cobre:

* diagnóstico de dependências e conflitos,
* uso do `depmod`, `modprobe` e `dkms`,
* reconstrução de módulos de terceiros,
* e como inspecionar logs de falha no carregamento.

---

## 🧩 1. Confirmar que o módulo está presente no sistema

```bash
find /lib/modules/$(uname -r) -type f -name "*.ko*" | grep nome_do_modulo
```

Se nada aparecer → o módulo não existe para esse kernel.
Verifique se há outro kernel instalado:

```bash
ls /lib/modules
```

Cada diretório representa um kernel instalado.
Você pode precisar atualizar para um kernel que inclua o driver desejado.

---

## ⚙️ 2. Recriar o índice de dependências (`depmod`)

O `depmod` gera os mapas que o `modprobe` usa para resolver dependências automáticas.

Execute:

```bash
sudo depmod -a
```

Depois, tente novamente:

```bash
sudo modprobe nome_do_modulo
```

Se funcionar após o `depmod`, o problema era apenas o índice desatualizado.

---

## 🔎 3. Listar dependências e símbolos do módulo

Para entender **por que um módulo falha ao carregar**, veja as dependências:

```bash
modinfo nome_do_modulo | grep depends
```

E verifique símbolos ausentes (causa comum de erro “Unknown symbol”):

```bash
sudo dmesg | grep nome_do_modulo
```

Saída típica:

```
nome_do_modulo: Unknown symbol usb_register_driver (err -2)
```

Isso significa que outro módulo (no caso, `usbcore`) precisa estar carregado antes.
→ Solução: use `modprobe` (que carrega dependências automaticamente), **não `insmod`**.

---

## 🧱 4. Forçar o carregamento em modo debug

Carregue o módulo com logging detalhado:

```bash
sudo modprobe nome_do_modulo dyndbg=+p
```

Se o módulo suportar *dynamic debug*, ele emitirá mensagens extras via `dmesg`.

---

## 🧰 5. Resolver falhas de assinatura (Secure Boot)

Em sistemas com **Secure Boot**, o kernel só carrega módulos assinados.
Se você compilou um módulo manualmente, ele pode ser rejeitado:

Verifique o log:

```bash
dmesg | grep -i "module signature"
```

Saída típica:

```
Lockdown: Loading of unsigned module is restricted; see man kernel_lockdown.7
```

Soluções possíveis:

* Desativar Secure Boot temporariamente no BIOS, **ou**
* Assinar manualmente o módulo:

```bash
sudo kmodsign sha512 MOK.priv MOK.der /path/to/modulo.ko
```

Depois registre a chave:

```bash
sudo mokutil --import MOK.der
```

E reinicie o sistema para confirmar o enrolamento da chave (MOK enrollment).

---

## 🧮 6. Verificar conflitos e drivers duplicados

Se o módulo correto não carrega, pode haver outro já associado ao mesmo dispositivo.

Liste o driver atual:

```bash
lspci -k | grep -A 3 "nome_do_dispositivo"
```

Se aparecer outro `Kernel driver in use: ...`, descarregue-o:

```bash
sudo modprobe -r driver_antigo
sudo modprobe driver_novo
```

Bloqueie o antigo para evitar recarga:

```bash
echo "blacklist driver_antigo" | sudo tee /etc/modprobe.d/blacklist-old-driver.conf
```

---

## 🧰 7. Quando o módulo é de terceiros — usar DKMS

**DKMS (Dynamic Kernel Module Support)** recompila módulos automaticamente quando o kernel é atualizado.

### a) Instalar o DKMS

```bash
sudo apt install dkms build-essential linux-headers-$(uname -r)
```

### b) Adicionar o módulo ao DKMS

Se o módulo está em `/usr/src/nomedodriver-x.y/`, faça:

```bash
sudo dkms add -m nomedodriver -v x.y
sudo dkms build -m nomedodriver -v x.y
sudo dkms install -m nomedodriver -v x.y
```

Depois verifique:

```bash
dkms status
```

### c) Reinstalar um módulo DKMS quebrado

```bash
sudo dkms remove -m nomedodriver -v x.y --all
sudo dkms install -m nomedodriver -v x.y
```

Assim o módulo será reconstruído para o kernel atual e para futuros upgrades.

---

## 🧩 8. Validar integridade e versão do módulo

Verifique se o módulo foi compilado para o kernel correto:

```bash
modinfo /path/to/modulo.ko | grep vermagic
uname -r
```

Se o `vermagic` não coincidir com o kernel em uso, ele **não será carregado**.
Solução: recompile o módulo com os *headers* do kernel atual.

---

## 🧠 9. Recompilando manualmente um módulo (quando não há DKMS)

Se você tem o código-fonte (`driver.c` e `Makefile`):

```bash
sudo apt install build-essential linux-headers-$(uname -r)
make
sudo insmod nome_do_modulo.ko
```

Para instalar permanentemente:

```bash
sudo cp nome_do_modulo.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a
sudo modprobe nome_do_modulo
```

---

## 🧩 10. Logs detalhados e diagnóstico final

Use:

```bash
journalctl -k -b | grep nome_do_modulo
```

ou, para observar o carregamento em tempo real:

```bash
sudo dmesg -w
```

---

## ✅ Conclusão (fechada)

> Mesmo que o módulo exista, ele pode falhar ao inicializar por dependências ausentes, conflito, assinatura inválida, versão incorreta ou firmware ausente.
> As ferramentas-chave para diagnóstico são:
> **`modinfo`**, **`dmesg`**, **`depmod`**, **`lsmod`**, **`dkms`** e **`journalctl`**.
> Com `depmod` e `modprobe`, você garante dependências resolvidas; com DKMS e assinatura, garante compatibilidade e persistência.

---

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
