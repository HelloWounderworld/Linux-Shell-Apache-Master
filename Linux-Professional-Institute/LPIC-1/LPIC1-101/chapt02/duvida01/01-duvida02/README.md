# **Bootloader**
Excelente pergunta — entender **o bootloader** é entender o elo entre o *firmware* (BIOS/UEFI) e o **kernel do sistema operacional**.

O bootloader é uma peça crítica da inicialização e, em sistemas Linux, domina muito do comportamento do *boot* e da seleção de sistemas.

Vamos ver isso em detalhes, de forma técnica e progressiva, até o nível do que acontece em memória.

---

## 🧩 1. Definição precisa

O **bootloader** é o **programa responsável por carregar o kernel do sistema operacional na memória RAM** e transferir o controle da execução para ele.

Ele atua como um **intermediário** entre:

* o **firmware da máquina** (BIOS ou UEFI), que apenas sabe inicializar dispositivos básicos e montar partições, e
* o **sistema operacional** (kernel), que precisa ser carregado em memória com parâmetros e contexto adequados.

Em outras palavras:

> O bootloader é o primeiro software executado pelo firmware após a fase de POST (Power-On Self Test), e o último antes do kernel do sistema operacional começar a rodar.

---

## 🧠 2. Onde ele se encaixa no processo de boot

Vamos ilustrar o fluxo clássico (no modo BIOS/Legacy):

```
[1] BIOS → [2] Bootloader → [3] Kernel → [4] Init/Systemd
```

E no modo moderno (UEFI):

```
[1] UEFI Firmware → [2] Boot Manager (EFI Bootloader) → [3] Kernel (EFI Stub) → [4] systemd/init
```

Assim:

* BIOS/UEFI carrega **o primeiro setor de boot (MBR ou ESP)**.
* O bootloader é executado a partir daí.
* Ele localiza e carrega o kernel (e o *initramfs*, se necessário).
* Passa parâmetros para o kernel (via *cmdline*).
* Transfere a execução: “a partir daqui, o controle é seu, kernel.”

---

## ⚙️ 3. Estrutura de um bootloader (em fases)

Um bootloader típico tem várias **etapas** ou **estágios**, porque não cabe tudo no primeiro setor do disco (512 bytes no modo BIOS).

### 🔹 Em modo BIOS (MBR)

* **Stage 1:** fica no MBR (primeiros 512 bytes do disco). É minúsculo. Apenas encontra e executa o próximo estágio.
* **Stage 1.5 (opcional):** carrega drivers básicos de sistema de arquivos (ext2, FAT, etc.) para poder ler o Stage 2.
* **Stage 2:** o verdadeiro carregador (por exemplo, `/boot/grub/core.img`), que mostra o menu, lê a configuração e carrega o kernel.

### 🔹 Em modo UEFI

* O bootloader é um executável no formato PE/COFF (como os programas do Windows), armazenado na partição EFI (`/boot/efi/EFI/...`), normalmente em:

  ```
  /boot/efi/EFI/grub/grubx64.efi
  /boot/efi/EFI/systemd/systemd-bootx64.efi
  /boot/efi/EFI/ubuntu/grubx64.efi
  ```
* O UEFI localiza esse arquivo e o executa diretamente, sem limitação de 512 bytes.

---

## 🧭 4. O que exatamente o bootloader faz

### 1️⃣ Inicializa ambiente mínimo

* Configura registradores, modo de CPU (real, protegido, long mode).
* Detecta memória disponível (via BIOS ou UEFI tables).
* Inicializa controladores básicos de disco.

### 2️⃣ Monta o sistema de arquivos de `/boot`

* Permite localizar o kernel (`vmlinuz`) e o *initramfs* (`initrd.img`).

### 3️⃣ Carrega o kernel e o initramfs na memória RAM

* Copia ambos para endereços apropriados em memória física.
* Monta a linha de comando (cmdline), com parâmetros como:

  ```
  root=/dev/sda2 ro quiet splash
  ```

### 4️⃣ Passa controle para o kernel

* Configura o ponteiro de entrada do kernel e executa o salto.
* A partir daqui, o kernel assume o controle total do hardware.

---

## 🧰 5. Exemplos de bootloaders no Linux

| Bootloader            | Contexto / Uso típico                                        | Arquivos principais                        |
| --------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| **GRUB2**             | O mais comum; suporta BIOS e UEFI, múltiplos sistemas        | `/boot/grub/grub.cfg`, `/etc/default/grub` |
| **LILO**              | Antigo, substituído pelo GRUB; mais simples                  | `/etc/lilo.conf`                           |
| **SYSLINUX/EXTLINUX** | Usado em pendrives e sistemas leves                          | `/boot/syslinux/syslinux.cfg`              |
| **systemd-boot**      | Bootloader minimalista da systemd (UEFI-only)                | `/boot/loader/entries/*.conf`              |
| **rEFInd**            | Interface gráfica moderna (UEFI); detecta OS automaticamente | `/boot/efi/EFI/refind/refind.conf`         |

---

## 🔍 6. Configurações e parâmetros

Os bootloaders armazenam suas configurações de inicialização:

* Parâmetros do kernel (`root=`, `quiet`, `acpi=off`, etc.)
* Lista de sistemas operacionais detectados
* Tempo do menu de boot
* Opções de recuperação, single-user mode, etc.

Exemplo do **GRUB** (`/boot/grub/grub.cfg`):

```cfg
menuentry 'Ubuntu' {
    linux   /boot/vmlinuz-6.2.0 root=UUID=1234 ro quiet splash
    initrd  /boot/initrd.img-6.2.0
}
menuentry 'Rescue Mode' {
    linux   /boot/vmlinuz-6.2.0 root=UUID=1234 ro single
    initrd  /boot/initrd.img-6.2.0
}
```

---

## 🧱 7. Importância do bootloader

O bootloader é **crítico** para todo o processo de inicialização.
Ele é responsável por:

1. **Iniciar o sistema operacional** — Sem ele, o kernel não é encontrado nem carregado.
2. **Permitir múltiplos sistemas (dual boot)** — Escolher qual OS carregar.
3. **Passar parâmetros de inicialização** — Para kernel e init.
4. **Recuperar o sistema** — Oferecer opções “Rescue Mode” e kernel alternativo.
5. **Flexibilidade** — Carregar sistemas a partir de partições, LVMs, RAID, redes, etc.
6. **Segurança** — Interagir com Secure Boot, assinar kernels, verificar integridade.

---

## 🔒 8. Segurança e integração moderna

Com **UEFI + Secure Boot**, os bootloaders ganharam novo papel:

* São **assinados digitalmente** para garantir que não foram adulterados.
* Verificam a assinatura do kernel e initramfs antes de carregar.
* Trabalham junto com o **shim** (um mini-bootloader assinado pela Microsoft para compatibilidade com Secure Boot).

Fluxo moderno:

```
UEFI firmware
    ↓
shimx64.efi (assinatura válida)
    ↓
grubx64.efi (verificado pelo shim)
    ↓
Kernel Linux (assinatura validada)
```

---

## 🧩 9. Diagnóstico e manipulação

Comandos úteis para diagnóstico:

* Ver qual bootloader está sendo usado:

  ```bash
  sudo efibootmgr -v      # UEFI
  sudo grub-install --version
  ls /boot/efi/EFI
  ```
* Atualizar o GRUB:

  ```bash
  sudo update-grub          # Debian/Ubuntu
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg  # RHEL/Fedora
  ```
* Reinstalar o bootloader:

  ```bash
  sudo grub-install /dev/sda
  ```

---

## 🧠 10. Resumo conceitual

| Etapa          | Componente               | Função principal                                                  |
| -------------- | ------------------------ | ----------------------------------------------------------------- |
| BIOS/UEFI      | Firmware                 | Inicializa hardware básico e entrega controle ao bootloader       |
| Bootloader     | GRUB, systemd-boot, etc. | Localiza e carrega o kernel, monta parâmetros, transfere execução |
| Kernel         | Linux                    | Inicializa subsistemas, monta o root filesystem                   |
| Init / systemd | Espaço de usuário        | Gera serviços, rede, login, etc.                                  |

---

## 🧭 11. Em resumo prático

* **Sem bootloader**, o kernel nunca é iniciado.
* **Com bootloader**, o kernel é carregado de forma controlada, com parâmetros e redundância.
* **Em UEFI**, ele atua como *gerente de inicialização* moderno, podendo até verificar assinaturas digitais.
* **No Linux**, o **GRUB2** é o padrão — flexível, compatível e extensível.

---
