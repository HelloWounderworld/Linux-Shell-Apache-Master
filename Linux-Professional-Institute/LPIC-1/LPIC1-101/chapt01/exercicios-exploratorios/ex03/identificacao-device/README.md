# **Dispositivos**

Perfeito 👏 — essa é uma das perguntas mais centrais (e também mais elegantes) do funcionamento interno do Linux moderno.
Vamos destrinchar **como o kernel identifica, nomeia e associa dispositivos** — desde o momento em que o hardware é detectado até ele aparecer para o usuário em `/dev`.

O que você vai ver abaixo vale tanto para **máquinas físicas** quanto **máquinas virtuais**, e também para **dispositivos hotplug (como USB)** ou **internos (como SATA, PCI, NVMe, etc.)**.

---

## 🧩 1. O ponto de partida: o kernel não “adivinha” nada

Quando o Linux é iniciado, o **firmware** (BIOS ou UEFI) entrega ao kernel uma **descrição da topologia do hardware**:

* que barramentos existem (PCI, USB, etc.);
* quais dispositivos estão conectados;
* e endereços de memória/IO correspondentes.

O kernel, então, **varre cada barramento conhecido** para encontrar dispositivos e identificar suas características.
Cada barramento tem seu próprio **driver de detecção (bus driver)**.

Exemplo de barramentos e detectores:

| Barramento  | Função de detecção no kernel  | Exemplo de comando      |
| ----------- | ----------------------------- | ----------------------- |
| PCI / PCIe  | `pci_scan_bus()`              | `lspci`                 |
| USB         | `usb_new_device()`            | `lsusb`                 |
| SCSI / SATA | `scsi_scan_target()`          | `lsscsi`                |
| NVMe        | `nvme_probe()`                | `nvme list`             |
| I²C / SPI   | `i2c_probe()` / `spi_probe()` | — (drivers específicos) |

---

## ⚙️ 2. Cada dispositivo tem uma “identidade” única

Cada dispositivo é identificado por **informações estruturadas**, que o kernel usa para saber:

* **quem ele é**,
* **em qual barramento está**,
* **qual driver o entende**.

Essa identificação segue um **modelo de dados interno** do kernel chamado **device model**, estruturado em `/sys`.

Por exemplo:

```
/sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
```

Esse caminho já te diz:

* Está no **barramento PCI** (controladora SATA);
* O dispositivo está no **host 0**, **target 0** (padrão SCSI);
* O kernel o registrou como **bloco de armazenamento → sda**.

Cada diretório em `/sys/devices/` tem atributos que o kernel preenche dinamicamente, como:

* `vendor`, `device` → identificadores do fabricante;
* `driver` → link simbólico para o módulo carregado;
* `uevent` → metadados usados pelo `udev`.

---

## 🧠 3. Associação automática com drivers (binding)

O kernel mantém uma **tabela de correspondência** entre:

1. **IDs de hardware conhecidos** (fornecidos pelo fabricante);
2. **Drivers que afirmam suportar esses IDs**.

Quando um dispositivo é detectado, o kernel percorre essa tabela e carrega o módulo compatível (caso ainda não esteja carregado).

Exemplo simplificado de driver PCI:

```c
static const struct pci_device_id my_driver_ids[] = {
    { PCI_DEVICE(0x8086, 0x10D3) }, // Intel Gigabit Ethernet
    { 0, }
};
```

Quando o kernel encontra um dispositivo com `vendor=8086` e `device=10D3`, ele automaticamente associa (`bind`) o driver `e1000e`.

Resultado:

```
/sys/bus/pci/drivers/e1000e/0000:00:19.0
```

---

## 🔁 4. O `uevent` e o papel do `udev`

Sempre que um dispositivo é:

* detectado,
* removido,
* ou alterado,

o kernel emite um **evento (uevent)** para o espaço do usuário.
Esse evento contém pares `chave=valor` descrevendo o dispositivo:

Exemplo:

```
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
SUBSYSTEM=block
DEVNAME=sda
DEVTYPE=disk
```

O daemon **`systemd-udevd`** escuta esses eventos e aplica as regras definidas em:

* `/etc/udev/rules.d/` (regras personalizadas)
* `/lib/udev/rules.d/` (regras padrão do sistema)

Ele pode:

* definir o nome do dispositivo (`/dev/sda`);
* ajustar permissões (`chmod`, `chown`);
* executar scripts (ex: automontar, iniciar serviços);
* ou simplesmente ignorar o evento.

Assim, o dispositivo aparece no sistema de forma usável, mesmo que tenha sido plugado *a quente* (hotplug).

---

## 📂 5. Como isso aparece para o usuário

Depois de toda essa cadeia de identificação e associação:

| Diretório       | O que representa                                        |
| --------------- | ------------------------------------------------------- |
| `/sys/devices/` | Estrutura hierárquica física do hardware (device model) |
| `/sys/bus/`     | Cada tipo de barramento (pci, usb, scsi, etc.)          |
| `/sys/class/`   | Agrupamentos por função (rede, bloco, som...)           |
| `/dev/`         | Interface prática de acesso (arquivos de dispositivo)   |

Exemplo:

```
/sys/bus/pci/devices/0000:00:19.0 → driver e1000e
/dev/sda → dispositivo de bloco
/dev/ttyUSB0 → serial via USB
/dev/nvme0n1 → NVMe PCIe
```

---

## 🧭 6. Identificação em diferentes arquiteturas

O kernel usa **mecanismos diferentes de detecção**, conforme a arquitetura:

| Arquitetura              | Fonte de informação         | Ferramenta de inspeção    |
| ------------------------ | --------------------------- | ------------------------- |
| x86 / x86_64             | BIOS / ACPI / PCI tables    | `lspci`, `dmidecode`      |
| ARM (Raspberry Pi, SBCs) | Device Tree (`/boot/dtbs/`) | `ls /proc/device-tree`    |
| Servidores modernos      | ACPI + PCIe + SMBIOS        | `lspci`, `lsusb`, `lsblk` |
| VMs (KVM, Xen, VMware)   | Virtio / Hypervisor API     | `lspci`, `lsmod`, `dmesg` |

Mesmo em casos sem PCI, a lógica é a mesma:

> O kernel lê uma descrição do hardware → instancia dispositivos → carrega drivers → envia eventos → cria /dev.

---

## 🧩 7. Resumo visual do processo

```
[1] Firmware/Device Tree informa o hardware
      ↓
[2] Kernel varre barramentos (/sys/bus/*)
      ↓
[3] Drivers compatíveis são carregados (modprobe)
      ↓
[4] /sys/devices/ é preenchido dinamicamente
      ↓
[5] Kernel emite eventos uevent
      ↓
[6] systemd-udevd aplica regras e cria /dev/xxx
      ↓
[7] Usuário pode interagir com o dispositivo
```

---

## 💬 Conclusão

> Em kernels Linux modernos, a **identificação de dispositivos** é um processo automatizado e dinâmico, que depende:
>
> 1. da **descrição do hardware** (fornecida pelo firmware ou Device Tree),
> 2. da **detecção em barramentos** (PCI, USB, etc.),
> 3. da **associação de drivers no kernel**, e
> 4. da **criação de nós de dispositivo pelo udev**.
>
> O resultado é que o Linux reconhece e disponibiliza automaticamente dispositivos, sem intervenção manual — mas permite total controle quando necessário.

---

# **Nomenclaturas STA, IDE, SCSI, etc... e os caralhos a quatro**

- nomenclaturas

# **Diagrama das nomenclaturas**

- diagrama
