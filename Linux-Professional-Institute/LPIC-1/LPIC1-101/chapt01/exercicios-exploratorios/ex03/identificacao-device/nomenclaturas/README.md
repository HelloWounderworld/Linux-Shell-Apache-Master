# **Tipos de interfaces e protocolos de barramento de armazenamento**

Excelente 👏 — essa dúvida é **muito legítima** e **essencial** pra quem quer dominar Linux em nível de administração de sistemas e infraestrutura.

Esses termos (SATA, IDE, SCSI, NVMe etc.) são **tipos de interfaces e protocolos de barramento de armazenamento** — ou seja, definem **como o kernel conversa com dispositivos de disco** (HDs, SSDs, controladoras, etc.).

A seguir, vou te mostrar **cada tecnologia**, **como o kernel a enxerga**, **como identificar no sistema**, e **como elas evoluíram historicamente** — de IDE até NVMe, passando pelo SCSI e SATA.

---

## 🧩 1. IDE (ATA / PATA) — O Clássico Paralelo

**Nome completo:** *Integrated Drive Electronics* (ou PATA = *Parallel ATA*)
**Era:** até meados dos anos 2000
**Tipo:** barramento **paralelo**
**Conexão física:** cabos largos de 40 ou 80 vias

### 🔹 Características

* O **controlador IDE** era integrado ao próprio disco (por isso o nome “integrated”).
* Dois dispositivos por canal (Master e Slave).
* Comunicação paralela de 16 bits.
* Limitado em velocidade e distância.

### 🔹 No Linux

* Dispositivos apareciam como `/dev/hd[a-d]` (ex: `/dev/hda`, `/dev/hdb`).
* Kernel driver histórico: `ide`, depois substituído por `libata`.

### 🔹 Status atual

✅ **Obsoleto.**
Mas o suporte ainda existe por compatibilidade em kernels modernos (`CONFIG_ATA` → `libata` substitui IDE nativo).

---

## ⚙️ 2. SATA — O IDE Modernizado (Serial ATA)

**Nome completo:** *Serial ATA*
**Tipo:** barramento **serial** (ponto a ponto)
**Substitui:** IDE / PATA
**Usado em:** HDs e SSDs SATA convencionais.

### 🔹 Características

* Comunicação serial (não paralela).
* Cada dispositivo tem seu próprio canal (sem Master/Slave).
* Suporte a hotplug (conectar/desconectar com o sistema ligado).
* Usa o **protocolo ATA**, mas transportado via **camada física serial**.
* Controlado internamente pelo **sub–sistema SCSI** no Linux (via `libata`).

### 🔹 No Linux

* Dispositivos aparecem como `/dev/sdX` (mesmo esquema do SCSI).
* Drivers principais:

  * `ahci` (para controladoras modernas)
  * `libata` (abstração do kernel para o subsistema ATA/SATA)

### 🔹 Status atual

✅ **Amplamente usado ainda hoje**, especialmente em HDs e SSDs de 2.5”.

---

## 🚀 3. SCSI — O Protocolo Pai de Todos

**Nome completo:** *Small Computer System Interface*
**Tipo:** protocolo de comunicação **padronizado** para dispositivos de armazenamento e periféricos.
**Usado em:** discos, fitas, scanners, e emuladores virtuais (SAS, iSCSI, USB-storage).

### 🔹 Características

* Pode operar sobre vários **meios físicos**: paralelo, serial, rede (iSCSI).
* Protocolo extremamente versátil: suporta filas, comandos complexos, várias LUNs (Logical Unit Numbers).
* É um **modelo de comunicação**, não apenas um tipo de cabo.

### 🔹 No Linux

* O kernel tem um **sub–sistema SCSI central** que todos os outros (SATA, USB-storage, iSCSI, SAS) usam.
* Dispositivos aparecem como `/dev/sdX` (ex: `/dev/sda`, `/dev/sdb`).
* Drivers: `sd_mod`, `scsi_mod`, `libata`.

### 🔹 Status atual

✅ **Fundação da pilha moderna de armazenamento no Linux.**
Mesmo SSD SATA e USB usam SCSI como camada lógica.

---

## ⚙️ 4. SAS — O SCSI em versão Enterprise

**Nome completo:** *Serial Attached SCSI*
**Tipo:** barramento **serial** de alta velocidade
**Usado em:** servidores e storages corporativos

### 🔹 Características

* Evolução direta do SCSI paralelo.
* Compatível com dispositivos SATA (mas o inverso não é verdade).
* Permite múltiplos caminhos e redundância (multipath I/O).
* Muito usado em controladoras RAID profissionais.

### 🔹 No Linux

* Gerido também pelo **sub–sistema SCSI**.
* Dispositivos aparecem como `/dev/sdX`.
* Drivers: `mpt3sas`, `megaraid_sas`.

### 🔹 Status atual

✅ **Padrão enterprise**, robusto, confiável, e compatível com SCSI e SATA.

---

## ⚙️ 5. NVMe — O SSD falado diretamente pela CPU

**Nome completo:** *Non-Volatile Memory Express*
**Tipo:** protocolo de comunicação **PCI Express (PCIe)** direto
**Usado em:** SSDs modernos M.2, U.2, PCIe.

### 🔹 Características

* Dispensa completamente a pilha SCSI/ATA.
* Comunicação via **barramento PCIe**, diretamente mapeada na memória.
* Múltiplas filas paralelas e latência mínima.
* Criado especificamente para memórias NAND e flash (não discos mecânicos).

### 🔹 No Linux

* Sub–sistema próprio: `nvme_core`, `nvme`.
* Dispositivos aparecem como `/dev/nvme0n1`, `/dev/nvme1n1p1` etc.
* Comando de inspeção: `nvme list`.

### 🔹 Status atual

✅ **Padrão dominante** em servidores e notebooks modernos.
Desempenho muito superior ao SATA.

---

## ⚙️ 6. Outras interfaces relacionadas

| Interface            | Descrição                       | Kernel / Dispositivo                   |
| -------------------- | ------------------------------- | -------------------------------------- |
| **USB Mass Storage** | Discos externos via USB         | Usa camada SCSI (driver `usb-storage`) |
| **iSCSI**            | SCSI sobre TCP/IP (rede)        | `/dev/sdX` via `iscsi_tcp`             |
| **Virtio-blk**       | Dispositivos virtuais (VMs/KVM) | `/dev/vdX`                             |
| **MMC/SD**           | Cartões SD e eMMC (ARM)         | `/dev/mmcblkX`                         |

---

## 🧭 7. Mapa Resumido da Evolução

```
IDE (PATA)
   ↓ modernização física
SATA (usa SCSI logicamente)
   ↓ profissionalização
SAS (SCSI serial enterprise)
   ↓ evolução total de protocolo
NVMe (PCIe direto, sem SCSI)
```

E em paralelo, tudo que é USB, iSCSI, virtio etc. se conecta **lógica ou fisicamente ao modelo SCSI**.

---

## 🧠 8. Como identificar no Linux o tipo de barramento

### 📦 Listar todos os discos

```bash
lsblk -o NAME,MODEL,TRAN
```

Saída típica:

```
NAME   MODEL            TRAN
sda    ST1000DM010-2EP SATA
nvme0n1 Samsung SSD     nvme
sdb    SanDisk Ultra    usb
```

### 📜 Conferir detalhes via sysfs

```bash
cat /sys/block/sda/device/model
cat /sys/block/sda/device/subsystem
```

### 🔍 Ver módulos carregados

```bash
lsmod | grep -E 'ata|scsi|nvme|sas'
```

---

## 🧩 9. Resumo comparativo

| Interface       | Tipo de barramento | Protocolo usado         | Dispositivo em `/dev` | Suporte no kernel |
| --------------- | ------------------ | ----------------------- | --------------------- | ----------------- |
| **IDE (PATA)**  | Paralelo           | ATA                     | `/dev/hdX`            | Legado            |
| **SATA**        | Serial             | ATA via SCSI (`libata`) | `/dev/sdX`            | Ativo             |
| **SCSI**        | Paralelo/Serial    | SCSI                    | `/dev/sdX`            | Base universal    |
| **SAS**         | Serial             | SCSI                    | `/dev/sdX`            | Enterprise        |
| **NVMe**        | PCIe               | NVMe                    | `/dev/nvmeXnY`        | Moderno           |
| **USB Storage** | USB                | SCSI                    | `/dev/sdX`            | Ativo             |
| **iSCSI**       | Rede               | SCSI                    | `/dev/sdX`            | Ativo             |

---

## 💬 Conclusão

> Em kernels modernos do Linux, **quase todos os dispositivos de armazenamento** (mesmo SSD SATA e USB) **falam o protocolo SCSI** internamente.
> O SCSI virou o “língua franca” da pilha de armazenamento.
> O **NVMe** é o sucessor natural — desenhado para memórias flash e comunicação direta via **PCI Express**, sem intermediários.
>
> O kernel abstrai tudo isso de modo uniforme, expondo tudo em `/dev` como dispositivos de bloco (`/dev/sdX`, `/dev/nvmeXnY`, etc.) e gerindo via subsistemas como `libata`, `sd_mod`, `nvme_core`, `usb-storage`.

---

Quer que eu te mostre **um mapa visual completo da pilha de armazenamento do kernel Linux**, com os módulos (`libata`, `sd_mod`, `nvme`), os barramentos (`PCI`, `USB`, `SATA`) e como eles se conectam até `/dev`?
Isso deixa a arquitetura super clara.
