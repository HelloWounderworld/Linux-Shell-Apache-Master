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