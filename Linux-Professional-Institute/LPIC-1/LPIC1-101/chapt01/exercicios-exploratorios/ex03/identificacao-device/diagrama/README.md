# 🧭 Visão Geral — Da Placa à Camada de Bloco

Perfeito 👌 — então vamos montar um **mapa visual completo** da pilha de armazenamento do **kernel Linux moderno**, mostrando **desde o hardware físico (barramento)** até o que você realmente vê como arquivo de dispositivo em `/dev/`.

A ideia é entender **como o kernel conversa com qualquer tipo de disco**, seja um SSD NVMe moderno, um HD SATA, um storage USB ou até um disco virtual de uma VM.

---

```
┌────────────────────────────────────────────┐
│         Usuário / Espaço de Aplicação       │
├────────────────────────────────────────────┤
│     /dev/sdX, /dev/nvmeXnY, /dev/vdX       │ ← dispositivos de bloco
│     lsblk, fdisk, mkfs, mount, etc.        │
├────────────────────────────────────────────┤
│        Camada de Gerenciamento de Blocos   │
│ (block layer: schedulers, multipath, LVM)  │
├────────────────────────────────────────────┤
│           Sub-sistemas de Armazenamento     │
│                                              │
│ ┌─────────────┬────────────┬────────────┬──────────────┐
│ │   libata    │   sd_mod   │  nvme_core│  virtio_blk  │
│ │ (ATA/SATA)  │ (SCSI base)│ (NVMe)    │ (VMs)        │
│ └─────────────┴────────────┴────────────┴──────────────┘
├────────────────────────────────────────────┤
│             Camada de Drivers              │
│────────────────────────────────────────────│
│ ahci, mpt3sas, megaraid_sas, usb-storage, │
│ iscsi_tcp, nvme, virtio_pci, etc.         │
├────────────────────────────────────────────┤
│          Camada de Barramento (Bus)       │
│────────────────────────────────────────────│
│ PCI / PCIe / USB / SATA / SAS / iSCSI / MMC │
├────────────────────────────────────────────┤
│             Hardware Físico                │
│────────────────────────────────────────────│
│ HDs, SSDs, controladoras, storages, etc.  │
└────────────────────────────────────────────┘
```

---

## 🔹 1. Camada de Barramento

Essa é a camada **mais próxima do hardware**.
Ela representa o **meio físico e elétrico** usado para conectar o dispositivo ao sistema.

**Principais tipos:**

| Barramento     | Exemplo de dispositivo              | Kernel detecta via             |
| -------------- | ----------------------------------- | ------------------------------ |
| **PCI / PCIe** | Placas NVMe, controladoras SATA/SAS | `/sys/bus/pci`                 |
| **USB**        | HDs externos, pendrives             | `/sys/bus/usb`                 |
| **SATA**       | HDs e SSDs internos                 | `/sys/bus/ata` (via PCIe/AHCI) |
| **SAS**        | Storages empresariais               | `/sys/bus/scsi`                |
| **iSCSI**      | Storages via rede TCP/IP            | `/sys/bus/iscsi`               |
| **MMC/SD**     | eMMC e cartões SD                   | `/sys/bus/mmc`                 |

👉 *O kernel detecta o hardware durante o boot via udev/sysfs e cria os pseudo-arquivos correspondentes.*

---

## 🔹 2. Camada de Drivers

Aqui estão os **módulos de kernel específicos** para cada tipo de barramento.
Eles sabem **como conversar com o hardware físico**.

**Exemplos:**

| Driver                     | Descrição                        | Tipo de dispositivo |
| -------------------------- | -------------------------------- | ------------------- |
| `ahci`                     | Controladoras SATA modernas      | SATA                |
| `libata`                   | Abstração ATA/SATA unificada     | SATA / IDE          |
| `mpt3sas`, `megaraid_sas`  | Controladoras SAS e RAID         | SAS                 |
| `nvme`                     | SSDs NVMe via PCIe               | NVMe                |
| `usb-storage`              | Armazenamento USB (mass storage) | USB                 |
| `iscsi_tcp`                | Storage remoto iSCSI             | Rede                |
| `virtio_pci`, `virtio_blk` | Dispositivos virtuais (VMs)      | Virtualização       |

Esses módulos são carregados dinamicamente conforme o kernel detecta o hardware (`modprobe`/`udev`).

---

## 🔹 3. Sub–sistemas de Armazenamento

Essa camada transforma os drivers específicos em uma **interface genérica e uniforme**.

| Sub–sistema                     | Função                                         | Protocolos Suportados |
| ------------------------------- | ---------------------------------------------- | --------------------- |
| **SCSI (`scsi_mod`, `sd_mod`)** | Modelo unificado para discos, fitas e storages | SATA, SAS, USB, iSCSI |
| **libata**                      | Traduz comandos ATA → SCSI                     | SATA / IDE            |
| **NVMe (`nvme_core`)**          | Sub–sistema próprio para SSDs NVMe             | PCIe                  |
| **VirtIO (`virtio_blk`)**       | Sub–sistema de blocos para VMs                 | Virtual               |
| **MMC/SD (`mmc_block`)**        | Discos embutidos em ARM                        | eMMC / SD             |

👉 O **SCSI é o “língua franca”** da pilha de armazenamento.
Mesmo SATA e USB Mass Storage são tratados internamente como SCSI.

---

## 🔹 4. Camada de Blocos

Agora o kernel já vê o dispositivo como um **disco genérico de blocos**.

Essa camada:

* Gerencia filas de I/O
* Aplica algoritmos de escalonamento (BFQ, MQ, CFQ, etc.)
* Interage com sistemas de arquivos (ext4, xfs, btrfs)

### Exemplos de dispositivos de bloco:

| Dispositivo   | Tipo real     | Aparece como   |
| ------------- | ------------- | -------------- |
| HD SATA       | Físico (SATA) | `/dev/sda`     |
| SSD NVMe      | PCIe          | `/dev/nvme0n1` |
| Pendrive      | USB           | `/dev/sdb`     |
| Disco iSCSI   | Rede          | `/dev/sdc`     |
| Disco virtual | VM (virtio)   | `/dev/vda`     |

---

## 🔹 5. Espaço de Usuário

Aqui entram as ferramentas e camadas de software usadas para:

* Gerenciar discos (fdisk, parted)
* Montar volumes (mount)
* Gerenciar partições lógicas (LVM, dm-crypt, RAID)
* Criar sistemas de arquivos (mkfs)

### Exemplo:

```bash
fdisk -l
lsblk -o NAME,TRAN,MODEL
udevadm info /dev/sda
```

---

# 🧱 Fluxo Real: do Boot ao /dev/sdX

```
[BIOS/UEFI]
   ↓
Detecta controladora PCI (ex: AHCI)
   ↓
Kernel carrega driver correspondente (ex: ahci)
   ↓
Driver AHCI usa libata → cria interface SCSI
   ↓
Sub–sistema SCSI cria /dev/sda
   ↓
udev aplica regras → dá nome, permissões, symlink
   ↓
Usuário acessa /dev/sda (ou monta partição)
```

---

## 🧩 Exemplo de Caminhos em `/sys`

Quer ver tudo isso **ao vivo**?

### 1️⃣ Descubra o tipo de transporte (barramento):

```bash
lsblk -o NAME,TRAN
```

### 2️⃣ Veja o caminho no sysfs:

```bash
udevadm info -q path -n /dev/sda
```

### 3️⃣ Veja os drivers associados:

```bash
ls -l /sys/block/sda/device/driver
```

### 4️⃣ Veja o subsistema:

```bash
ls -l /sys/block/sda/device/subsystem
```

### 5️⃣ E o módulo do kernel:

```bash
lspci -k | grep -A3 -i sata
```

---

# 📊 Comparativo Visual — Sub–sistemas e Barramentos

| Tipo físico | Driver principal | Sub–sistema       | Nome em `/dev`      | Protocolo interno |
| ----------- | ---------------- | ----------------- | ------------------- | ----------------- |
| IDE / PATA  | `pata_*`         | `libata`          | `/dev/hdX` (legado) | ATA               |
| SATA        | `ahci`           | `libata` + `SCSI` | `/dev/sdX`          | ATA/SCSI          |
| SAS         | `mpt3sas`        | `SCSI`            | `/dev/sdX`          | SCSI              |
| NVMe        | `nvme`           | `nvme_core`       | `/dev/nvmeXnY`      | NVMe              |
| USB Storage | `usb-storage`    | `SCSI`            | `/dev/sdX`          | SCSI              |
| iSCSI       | `iscsi_tcp`      | `SCSI`            | `/dev/sdX`          | SCSI              |
| VirtIO      | `virtio_blk`     | `virtio`          | `/dev/vdX`          | VirtIO            |

---

## 🧠 Conclusão Geral

* O **kernel Linux moderno** organiza todo o armazenamento em **camadas**:
  *barramento → driver → subsistema → bloco → /dev.*

* A **unificação em torno do SCSI** é o que torna possível que **tudo pareça igual** para o usuário, mesmo com tecnologias completamente diferentes por baixo.

* **NVMe** é o primeiro grande salto fora do modelo SCSI, por ser feito sob medida para SSDs via PCIe.

* O **`udev` + `/sys`** garante que o kernel e o espaço de usuário se comuniquem em tempo real, gerando os dispositivos e links automaticamente.

---
