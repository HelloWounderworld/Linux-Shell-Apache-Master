# 🧭 Mapa completo do processo de boot do Linux moderno
Perfeito 😎 — então vamos montar um **mapa completo e visual** do processo de *boot* do Linux, passo a passo, mostrando **como o bootloader se encaixa** entre o firmware e o kernel, o que cada camada faz, e onde ficam os arquivos envolvidos.

---

## 🧱 1. Visão geral (camadas do boot)

```
┌────────────────────────────────────────────────────────────┐
│                     HARDWARE / FIRMWARE                    │
│        (BIOS ou UEFI inicializa CPU, RAM, discos, etc.)    │
└────────────────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│                        BOOTLOADER                         │
│  (GRUB2, systemd-boot, SYSLINUX, LILO, etc.)               │
│  - Localiza e carrega o kernel                             │
│  - Passa parâmetros de boot                                │
│  - Pode exibir menu (multi-boot)                           │
└────────────────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│                           KERNEL                           │
│  (vmlinuz)                                                  │
│  - Inicializa hardware e memória                            │
│  - Monta sistemas /proc, /sys, etc.                         │
│  - Carrega initramfs (sistema raiz temporário)              │
│  - Executa processo PID 1 (systemd/init)                    │
└────────────────────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────┐
│                    INIT / SYSTEMD (USER SPACE)             │
│  - Monta rootfs final                                      │
│  - Inicia serviços, rede, login                            │
│  - Transfere controle total ao usuário                     │
└────────────────────────────────────────────────────────────┘
```

---

## ⚙️ 2. Etapas detalhadas — BIOS / UEFI até kernel

### 🔹 [1] Firmware (BIOS ou UEFI)

**Função:** inicializar hardware básico (POST) e localizar o *bootloader*.

| Tipo          | Onde busca o bootloader         | Exemplo de arquivo                   |
| ------------- | ------------------------------- | ------------------------------------ |
| BIOS (Legacy) | Primeiro setor do disco (MBR)   | 512 bytes com código binário         |
| UEFI          | Partição EFI (`/boot/efi/EFI/`) | `grubx64.efi`, `systemd-bootx64.efi` |

📘 **Obs:**
No modo UEFI, o firmware lê diretamente arquivos de uma partição FAT32 chamada **ESP** (*EFI System Partition*), o que elimina a limitação de 512 bytes do modo BIOS.

---

### 🔹 [2] Bootloader (GRUB / systemd-boot)

**Responsável por:**

* Mostrar o menu de sistemas.
* Carregar o kernel (`vmlinuz`) e o initramfs (`initrd.img`).
* Passar parâmetros de boot (`root=`, `ro`, `quiet`, `systemd.unit=`, etc.).
* Saltar para o kernel (transferência de controle).

**Arquivos típicos:**

```
/boot/grub/grub.cfg
/etc/default/grub
/boot/vmlinuz-6.8.0-35-generic
/boot/initrd.img-6.8.0-35-generic
```

**Etapas internas (modo BIOS):**

```
Stage 1  → MBR (512 bytes)
Stage 1.5 → Core loader (drivers FS básicos)
Stage 2  → Menu + carregamento do kernel
```

**Etapas internas (modo UEFI):**

```
UEFI → grubx64.efi (na partição /boot/efi/EFI/)
     → lê /boot/grub/grub.cfg
     → carrega kernel + initramfs
```

---

### 🔹 [3] Kernel (vmlinuz)

Após o bootloader carregar o kernel na memória e passar o controle, o kernel:

1. **Inicializa o hardware** (configura CPU, memória, PCI, drivers iniciais).
2. **Cria os pseudo-sistemas:**

   * `/proc` — informações sobre processos.
   * `/sys` — visão dos dispositivos (sysfs).
   * `/dev` — gerenciado por `udev` (nós de dispositivos).
3. **Descompacta o initramfs** (imagem temporária de root filesystem).
4. **Executa o processo inicial (`/init`) dentro do initramfs.**

**Arquivos:**

```
/boot/vmlinuz-*
/boot/initrd.img-*
```

---

### 🔹 [4] Initramfs (sistema raiz temporário)

Serve para:

* Carregar módulos essenciais (controladores de disco, drivers, etc.).
* Montar o **root filesystem real** (ex: `/dev/sda2` ou LVM, RAID, etc.).
* Montar criptografia (LUKS, etc.).
* Transferir controle ao `init` real (systemd ou SysV).

Fluxo:

```
Kernel → carrega initramfs → roda /init → monta root real → exec /sbin/init
```

Você pode inspecionar o conteúdo do seu initramfs:

```bash
lsinitramfs /boot/initrd.img-$(uname -r)
```

---

### 🔹 [5] Systemd (ou init clássico)

Agora, o sistema já está em **user space**:

* O PID 1 é o **systemd** (ou `/sbin/init`).
* Monta os sistemas de arquivos finais (`/`, `/home`, `/var`, `/tmp`, etc.).
* Inicializa serviços, rede, usuários, e o ambiente gráfico (se houver).

---

## 🧩 3. Exemplo prático: caminho do bootloader ao kernel

Suponha o seguinte `grub.cfg`:

```cfg
menuentry 'Ubuntu 24.04 LTS' {
    insmod gzio
    insmod part_gpt
    insmod ext2
    set root='hd0,gpt2'
    linux   /boot/vmlinuz-6.8.0-35-generic root=UUID=abc123 ro quiet splash
    initrd  /boot/initrd.img-6.8.0-35-generic
}
```

Fluxo executado:

```
BIOS/UEFI  →  GRUB
               ↓
          Carrega /boot/vmlinuz-6.8.0-35-generic
               ↓
          Carrega /boot/initrd.img-6.8.0-35-generic
               ↓
          Passa parâmetros "root=UUID=abc123 ro quiet splash"
               ↓
          Kernel inicializa e monta initramfs
               ↓
          initramfs monta /dev/sda2 (root real)
               ↓
          systemd inicia sistema operacional
```

---

## 🧠 4. Visualização simplificada em camadas

```
┌──────────────────────────────────────────────┐
│                Hardware (CPU, RAM, Discos)   │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ Firmware (BIOS/UEFI)                         │
│ - POST                                       │
│ - Busca bootloader (MBR ou EFI)              │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ Bootloader (GRUB / systemd-boot / LILO)      │
│ - Mostra menu de boot                        │
│ - Carrega kernel e initramfs                 │
│ - Passa cmdline                              │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ Kernel (vmlinuz)                             │
│ - Inicializa hardware                        │
│ - Monta /proc, /sys, /dev                    │
│ - Carrega initramfs                          │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ Initramfs                                    │
│ - Carrega módulos essenciais                 │
│ - Monta root filesystem                      │
│ - Executa /sbin/init ou systemd              │
└──────────────────────────────────────────────┘
                      │
                      ▼
┌──────────────────────────────────────────────┐
│ User Space (systemd, login, shell, GUI)      │
│ - Inicializa serviços                        │
│ - Fornece ambiente de usuário                │
└──────────────────────────────────────────────┘
```

---

## 🔎 5. Comandos úteis de inspeção

* Ver parâmetros de boot:

  ```bash
  cat /proc/cmdline
  ```
* Ver kernel atual:

  ```bash
  uname -a
  ```
* Ver informações de bootloader (UEFI):

  ```bash
  sudo efibootmgr -v
  ```
* Ver logs do boot:

  ```bash
  journalctl -b
  ```
* Editar configurações do GRUB:

  ```bash
  sudo nano /etc/default/grub
  sudo update-grub
  ```

---

## 💡 6. Analogia rápida

Pense assim:

| Etapa        | Analogia                                                                           |
| ------------ | ---------------------------------------------------------------------------------- |
| BIOS/UEFI    | Porteiro que liga as luzes e abre a porta principal                                |
| Bootloader   | Recepcionista que te apresenta as opções de entrada e te leva até o programa certo |
| Kernel       | O “motor” do sistema operacional — controla o hardware                             |
| Initramfs    | O assistente que prepara o ambiente para o sistema real                            |
| Systemd/init | O gerente que liga todos os serviços e te entrega o login                          |

---

Se quiser, posso agora te mostrar **a versão estendida do mapa**, com os **endereços de memória aproximados** e o **que cada estágio faz tecnicamente (carregamento, modo protegido, real mode → long mode, saltos de execução, etc.)**, pra entender o *boot* até o nível de registradores da CPU.

Quer que eu te mostre essa versão “arquitetural profunda” também?
