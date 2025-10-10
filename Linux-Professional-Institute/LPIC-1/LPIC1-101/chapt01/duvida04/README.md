# **Os diretórios `/proc` e `/sys`**

Excelente questão 👏 — e você está **muito bem encaminhado** na linha de raciocínio.
De fato, os diretórios **`/proc`** e **`/sys`** são **pseudosistemas de arquivos (virtual filesystems)**, ou seja, eles **não armazenam dados reais em disco**, mas sim **informações geradas dinamicamente pelo kernel em tempo de execução**.

Vamos detalhar isso passo a passo, de forma bem sólida 👇

---

## 🧩 1. O que realmente são `/proc` e `/sys`

Tanto `/proc` quanto `/sys` são **sistemas de arquivos virtuais** — o conteúdo deles **não existe fisicamente no disco**, mas é **criado e mantido em memória pelo kernel** enquanto o sistema está rodando.
Eles servem como **interfaces de comunicação entre o espaço do usuário e o kernel**.

| Diretório | Sistema de arquivos | Finalidade principal                                                      |
| --------- | ------------------- | ------------------------------------------------------------------------- |
| `/proc`   | `procfs`            | Expor **informações sobre processos e parâmetros do kernel**              |
| `/sys`    | `sysfs`             | Expor **informações sobre dispositivos, drivers e subsistemas do kernel** |

---

## ⚙️ 2. Eles não são criados por scripts — mas pelo kernel

Sua hipótese é boa (e lógica), mas o kernel **não é implementado em shell script**.
O Linux é majoritariamente escrito em **C e Assembly**, e dentro do código do kernel existem *submódulos* responsáveis por montar automaticamente esses sistemas virtuais durante a inicialização.

Por exemplo, durante o boot, o kernel executa algo equivalente a:

```c
mount("proc", "/proc", "proc", 0, NULL);
mount("sysfs", "/sys", "sysfs", 0, NULL);
```

Esses comandos internos fazem o kernel “montar” essas interfaces virtuais no espaço de nomes de arquivos do sistema.
Portanto, eles **não são criados por processos de usuário nem por scripts**, mas sim **pelo próprio kernel durante a inicialização**.

---

## 🧠 3. O `/proc` (Process Information)

O `/proc` existe desde os primórdios do Linux e contém **informações sobre processos e parâmetros de execução do kernel**.

Exemplos:

* `/proc/cpuinfo` → informações da CPU
* `/proc/meminfo` → uso de memória
* `/proc/uptime` → tempo de atividade do sistema
* `/proc/[PID]/` → diretórios criados dinamicamente para cada processo ativo (ex.: `/proc/1/`, `/proc/1234/`)

Esses diretórios desaparecem assim que o processo termina — ou seja, o `/proc` reflete **em tempo real** o que está na RAM e nas estruturas internas do kernel.

---

## ⚙️ 4. O `/sys` (System Information)

O `/sys` é mais recente (surgiu com o kernel 2.6) e foi criado para expor informações de forma **mais organizada e orientada a dispositivos**.

Ele está ligado ao subsistema **`sysfs`** e reflete a **árvore de dispositivos do kernel** (drivers, barramentos, módulos, etc.).

Exemplos:

* `/sys/class/net/` → interfaces de rede
* `/sys/block/` → discos e partições
* `/sys/devices/` → topologia de hardware real
* `/sys/module/` → módulos de kernel carregados e seus parâmetros

Além disso, muitos arquivos em `/sys` **permitem escrita**, servindo para **configurar o kernel em tempo real**.
Por exemplo:

```bash
echo 0 | sudo tee /sys/class/leds/input3::capslock/brightness
```

(apaga o LED de Caps Lock no teclado)

---

## 🔁 5. Quando eles são criados e destruídos

Esses diretórios são **montados automaticamente no boot** (normalmente via `systemd` ou `init`) e **desmontados quando o sistema é desligado**.
Portanto:

* Eles **não são gravados em disco**;
* **Somem ao desligar o sistema**;
* **São recriados em cada inicialização**.

---

## 🧩 6. Em resumo

| Item         | `/proc`                                | `/sys`                                |
| ------------ | -------------------------------------- | ------------------------------------- |
| Tipo         | Sistema de arquivos virtual (`procfs`) | Sistema de arquivos virtual (`sysfs`) |
| Criado por   | Kernel (não shell script)              | Kernel (não shell script)             |
| Conteúdo     | Processos e parâmetros do kernel       | Dispositivos e drivers                |
| Persistência | Temporário (em memória)                | Temporário (em memória)               |
| Montagem     | Automática no boot                     | Automática no boot                    |

---

## ✅ Resumo refinado (versão curta e elegante)

> Os diretórios `/proc` e `/sys` são sistemas de arquivos virtuais criados pelo **kernel Linux** durante o processo de inicialização.
> Eles não existem fisicamente no disco — são estruturas em memória que permitem ao usuário e aos programas interagir diretamente com as informações internas do kernel.
>
> * `/proc` mostra informações sobre **processos e parâmetros do kernel**;
> * `/sys` mostra informações sobre **dispositivos e módulos de kernel**.
>
> Ambos são recriados a cada boot e desaparecem quando o sistema é desligado.

---

# 🧭 Anatomia do Boot Linux (com foco em `/proc` e `/sys`)

Vamos montar um **mapa técnico e cronológico** mostrando **como o kernel cria e monta `/proc` e `/sys` durante o processo de boot do Linux**, passo a passo, até o ponto em que o sistema já está com o **`udev` e o `systemd`** totalmente operacionais.

A ideia é que, ao final, você consiga enxergar claramente **em que momento cada subsistema entra em cena**, e **quem é responsável por montar e popular cada parte** da árvore de diretórios.

---

## 🧩 1. Fase 0 — Firmware (BIOS / UEFI)

* O computador liga, e o **firmware** (BIOS ou UEFI) faz o *POST* (Power-On Self Test).
* Localiza o **dispositivo de boot** (HD, SSD, etc.) e carrega o **bootloader** (por exemplo, GRUB2).

📍 **Neste ponto, `/proc` e `/sys` ainda não existem.**
O firmware apenas entrega o controle ao *bootloader*.

---

## 🧩 2. Fase 1 — Bootloader (ex: GRUB2)

* O **GRUB** carrega a **imagem do kernel** (`vmlinuz`) e, opcionalmente, o **initramfs** (RAM disk inicial).
* Ele passa parâmetros para o kernel (ex: `root=/dev/sda2`, `ro quiet splash`, etc.).

📍 **Ainda não há sistemas de arquivos montados.**
Apenas a imagem do kernel e o initramfs estão na memória.

---

## 🧩 3. Fase 2 — Inicialização do Kernel (fase “early user space”)

Quando o kernel é carregado na RAM e começa a ser executado:

### 🧠 3.1 — Inicialização interna do Kernel

O kernel:

* Detecta o processador e a memória;
* Inicializa os subsistemas internos (agendador, memória virtual, VFS, drivers básicos);
* Prepara o **Virtual File System (VFS)** — o sistema genérico de arquivos que servirá como base para tudo.

---

### 📁 3.2 — Montagem do `/proc` e `/sys`

Assim que o VFS está pronto, o kernel **monta dois sistemas de arquivos virtuais essenciais:**

```c
mount("proc", "/proc", "proc", 0, NULL);
mount("sysfs", "/sys", "sysfs", 0, NULL);
```

* `/proc` → fornece informações sobre **processos e parâmetros do kernel**
* `/sys` → fornece informações sobre **dispositivos, drivers e subsistemas do kernel**

📍 Isso ocorre **antes mesmo** de o initramfs ser montado.
Esses pontos são montados diretamente pelo próprio kernel — **sem depender de `systemd` nem de `udev`**.

---

### ⚙️ 3.3 — Montagem do Initramfs

Após montar `/proc` e `/sys`, o kernel:

* Monta o **initramfs** (um mini sistema de arquivos em memória);
* Executa o script inicial (`/init`) dentro dele.

O `/init` é um **binário ou script shell** responsável por:

* Montar o sistema de arquivos raiz real (`/`);
* Carregar drivers adicionais (via `modprobe`);
* Executar utilitários básicos (como `busybox`).

---

## 🧩 4. Fase 3 — Transição para o espaço do usuário (User Space)

Quando o initramfs termina de preparar o ambiente:

1. Ele desmonta a RAM inicial (ou a mantém montada em `/run/initramfs`);
2. Faz um *pivot_root* para o sistema de arquivos real (por exemplo, `/dev/sda2`);
3. Executa o processo **PID 1**, que será o **`/sbin/init`** ou o **`systemd`** (dependendo da distro).

---

## 🧩 5. Fase 4 — systemd entra em cena

Agora o `systemd` (ou outro init, como `sysvinit`) assume o controle.

Ele:

* Garante que `/proc`, `/sys`, `/dev`, `/run` e `/tmp` estejam devidamente montados;
* Gera unidades de montagem (`.mount`) se necessário;
* Inicializa serviços, sockets e targets de boot.

🧠 Importante:
Mesmo que o kernel já tenha montado `/proc` e `/sys` antes, o `systemd` **verifica e remonta** (se preciso) com as opções corretas, garantindo consistência e permissões apropriadas.

---

## 🧩 6. Fase 5 — `udev` (gerenciador de dispositivos)

* O **`udev`** (hoje parte do `systemd` como `systemd-udevd`) começa a escanear o `/sys`:

  * Ele lê os diretórios e atributos expostos pelo kernel em `/sys/class`, `/sys/devices`, `/sys/block`, etc.;
  * Cria automaticamente os **arquivos de dispositivo** em `/dev` (como `/dev/sda`, `/dev/ttyUSB0`, etc.);
  * Aplica regras definidas em `/etc/udev/rules.d/`.

📍 `/sys` é, portanto, **a principal fonte de informação** para o `udev`.

---

## 🧩 7. Fase 6 — Serviços de alto nível

Com `/proc`, `/sys` e `/dev` prontos:

* O `systemd` carrega módulos (`modprobe` via units);
* Monta partições (`/etc/fstab`);
* Inicia serviços de rede, display, etc.

A partir daí, o sistema está totalmente funcional.

---

## 🧭 Mapa cronológico simplificado

| Etapa | Componente | O que acontece                       | Responsável por `/proc` e `/sys` |
| ----- | ---------- | ------------------------------------ | -------------------------------- |
| 0     | BIOS/UEFI  | POST, escolhe disco de boot          | —                                |
| 1     | GRUB       | Carrega kernel + initramfs           | —                                |
| 2     | Kernel     | Inicializa memória, CPU, subsistemas | Kernel                           |
| 3     | Kernel     | Monta `/proc` e `/sys`               | Kernel                           |
| 4     | Kernel     | Monta initramfs e executa `/init`    | Kernel                           |
| 5     | `/init`    | Monta raiz real (`/`)                | Initramfs                        |
| 6     | systemd    | Verifica e (re)monta `/proc`, `/sys` | systemd                          |
| 7     | udev       | Lê `/sys` e cria `/dev`              | udev                             |
| 8     | systemd    | Inicia serviços e usuários           | —                                |

---

## 🧠 Resumo técnico

* `/proc` e `/sys` **nascem dentro do kernel**, não de processos de usuário;
* são montados **ainda na fase inicial do boot**, antes mesmo do init;
* o `systemd` e o `udev` **interagem** com eles, mas **não os criam**;
* o `/sys` é a “árvore de dispositivos” viva do kernel;
* o `/proc` é o “espelho” do estado interno de processos e parâmetros do kernel.

---

# 🧭 **Anatomia do Boot Linux — Diagrama de Montagem do `/proc` e `/sys`**

Abaixo está um **diagrama visual e hierárquico** que representa **toda a linha de inicialização do Linux**, com foco especial em **como e quando `/proc` e `/sys` são criados e utilizados**.

---

```
──────────────────────────────────────────────────────────────
│                  🖥️  FIRMWARE / BIOS / UEFI                │
│────────────────────────────────────────────────────────────│
│  - Executa o POST (Power-On Self Test)                     │
│  - Identifica dispositivos de boot                         │
│  - Carrega o Bootloader (ex: GRUB2)                        │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                    ⚙️  BOOTLOADER (GRUB)                    │
│────────────────────────────────────────────────────────────│
│  - Carrega o kernel (vmlinuz) e o initramfs para a RAM      │
│  - Passa parâmetros de boot (ex: root=/dev/sda2)            │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│               🧠  KERNEL — FASE DE INICIALIZAÇÃO             │
│────────────────────────────────────────────────────────────│
│  1️⃣  Inicializa CPU, memória e VFS                         │
│  2️⃣  Cria subsistemas internos                             │
│  3️⃣  Monta sistemas virtuais:                             │
│        ├─ mount("proc", "/proc", "proc", 0, NULL)           │
│        └─ mount("sysfs", "/sys", "sysfs", 0, NULL)          │
│                                                            │
│  → /proc → estrutura de processos e parâmetros do kernel    │
│  → /sys  → estrutura de dispositivos, drivers e módulos     │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                   🗂️  INITRAMFS (RAM Disk Inicial)           │
│────────────────────────────────────────────────────────────│
│  - Kernel monta o initramfs                                 │
│  - Executa o script/binário /init                           │
│  - Carrega módulos adicionais (ex: drivers de storage)      │
│  - Monta o sistema raiz real (/)                            │
│  - Executa pivot_root → transfere controle para o / real    │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                 ⚙️  PID 1 — INIT / SYSTEMD                   │
│────────────────────────────────────────────────────────────│
│  - systemd assume como processo PID 1                       │
│  - Garante que /proc, /sys, /dev e /run estão montados      │
│  - (re)monta /proc e /sys se necessário                     │
│  - Inicializa alvos (targets), unidades (services, mounts)  │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                 🔌  UDEV (Gerenciador de Dispositivos)       │
│────────────────────────────────────────────────────────────│
│  - Lê informações de /sys                                   │
│  - Cria nós de dispositivos em /dev                         │
│  - Aplica regras de nomeação e permissões                   │
│  - Popula /dev dinamicamente                                │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│               🧩  SERVIÇOS DE ALTO NÍVEL (User Space)        │
│────────────────────────────────────────────────────────────│
│  - Montagem de partições (fstab)                            │
│  - Serviços de rede, login, display                         │
│  - Inicialização completa do ambiente de usuário            │
──────────────────────────────────────────────────────────────
```

---

## 🧠 **Resumo funcional (em sequência lógica)**

| Etapa          | Responsável                 | Função                            | Momento da criação de `/proc` e `/sys` |
| -------------- | --------------------------- | --------------------------------- | -------------------------------------- |
| 1️⃣ BIOS/UEFI  | Firmware                    | Carrega bootloader                | Ainda não existem                      |
| 2️⃣ GRUB       | Bootloader                  | Carrega kernel/initramfs          | Ainda não existem                      |
| 3️⃣ Kernel     | Núcleo do SO                | Monta `/proc` e `/sys`            | ✅ Criados aqui                         |
| 4️⃣ Initramfs  | Script `/init`              | Prepara e monta `/` real          | `/proc` e `/sys` já ativos             |
| 5️⃣ systemd    | Init PID 1                  | (Re)monta `/proc`, `/sys`, `/dev` | Revalida montagem                      |
| 6️⃣ udev       | Gerenciador de dispositivos | Lê `/sys`, cria `/dev`            | Usa `/sys` como base                   |
| 7️⃣ User Space | Serviços do sistema         | Finaliza boot                     | `/proc` e `/sys` prontos               |

---

## 🧩 **Como esses diretórios interagem**

```
          Kernel (núcleo)
          ├── /proc → process info, parâmetros, PID, memória
          └── /sys  → dispositivos, drivers, módulos
                        │
                        ▼
                 systemd-udevd
                    │
                    ▼
                 /dev (device nodes)
```

Ou seja:

* `/proc` = visão do kernel sobre **o que está rodando**
* `/sys`  = visão do kernel sobre **o que está conectado**
* `/dev`  = interface concreta criada a partir das informações do `/sys`

---

## ✅ **Resumo final**

> O `/proc` e o `/sys` são montados diretamente pelo kernel ainda na fase inicial do boot, antes mesmo do `init` ou `systemd`.
> O `systemd` apenas garante sua consistência, e o `udev` usa o `/sys` como base para criar os dispositivos em `/dev`.
> Juntos, esses três diretórios formam a “coluna vertebral” da comunicação entre **o kernel e o espaço do usuário** no Linux.

---

# 🧬 **Anatomia do Núcleo Vivo do Linux**

Agora vamos montar a **versão concentrada** do diagrama:
a **anatomia do “núcleo vivo” do Linux**, mostrando **como o kernel se relaciona com `/proc`, `/sys` e `/dev`**, e como esses três diretórios formam a base de comunicação entre **hardware, kernel e espaço do usuário**.

---

*(foco em `/proc`, `/sys` e `/dev`)*

```
┌──────────────────────────────────────────────────────────┐
│                    🧠 KERNEL LINUX                       │
│──────────────────────────────────────────────────────────│
│  - Núcleo do sistema operacional                         │
│  - Controla CPU, memória, drivers e processos             │
│  - Fornece interfaces virtuais para o espaço do usuário   │
│                                                          │
│  Estruturas internas principais:                         │
│    • task_struct → informações de processos               │
│    • module_struct → módulos carregados                   │
│    • device_struct → dispositivos físicos/lógicos         │
│                                                          │
│  Interfaces expostas (montadas na memória):               │
│    ├── /proc → Processos e parâmetros do kernel           │
│    └── /sys  → Dispositivos, drivers e módulos            │
└──────────────────────────────────────────────────────────┘
            │
            │  🔁 Comunicação direta (Kernel <-> User Space)
            ▼
┌──────────────────────────────────────────────────────────┐
│                🗂️  PSEUDOSISTEMAS DE ARQUIVOS            │
│──────────────────────────────────────────────────────────│
│                                                          │
│  📂 /proc (procfs)                                       │
│   - Criado pelo kernel logo após inicialização            │
│   - Representa processos e parâmetros                     │
│   - Ex: /proc/cpuinfo, /proc/meminfo, /proc/[PID]/        │
│                                                          │
│  📂 /sys (sysfs)                                         │
│   - Exibe árvore de dispositivos e módulos do kernel       │
│   - Ex: /sys/class/net, /sys/block, /sys/module/          │
│   - Permite escrita para configurar hardware em tempo real │
└──────────────────────────────────────────────────────────┘
            │
            │  🔄 Leitura e interpretação pelo espaço do usuário
            ▼
┌──────────────────────────────────────────────────────────┐
│                ⚙️  UDEV (systemd-udevd)                   │
│──────────────────────────────────────────────────────────│
│  - Demon do espaço do usuário que lê o /sys               │
│  - Identifica dispositivos (USB, disco, rede, etc.)       │
│  - Cria dinamicamente os arquivos correspondentes em:     │
│        📂 /dev                                            │
│    (ex: /dev/sda, /dev/ttyUSB0, /dev/null)                │
│  - Aplica regras de nomeação e permissões                 │
└──────────────────────────────────────────────────────────┘
            │
            │  🔁 /dev fornece interface concreta para o usuário
            ▼
┌──────────────────────────────────────────────────────────┐
│              👤  ESPAÇO DO USUÁRIO (User Space)           │
│──────────────────────────────────────────────────────────│
│  - Programas interagem com dispositivos via /dev           │
│  - Utilitários leem /proc e /sys para diagnósticos         │
│                                                          │
│  Exemplos:                                                │
│   • cat /proc/cpuinfo      → info da CPU                  │
│   • cat /sys/class/net/eth0/speed → velocidade da placa   │
│   • echo 1 > /sys/class/leds/.../brightness → acende LED  │
│   • ls /dev/ → lista de dispositivos disponíveis           │
└──────────────────────────────────────────────────────────┘
```

---

## 🧩 **Fluxo conceitual**

```
[Hardware físico]
      │
      ▼
🧠 [Kernel]
      │
      ├── /proc → visão lógica dos processos e parâmetros
      └── /sys  → visão lógica dos dispositivos e módulos
                     │
                     ▼
              ⚙️ udev lê /sys
                     │
                     ▼
                /dev → interfaces concretas para o usuário
                     │
                     ▼
          🧍 Usuário / Programas interagem com o kernel
```

---

## 🧠 **Explicação em camadas**

| Camada             | Função                                                 | Exemplo prático                  |
| ------------------ | ------------------------------------------------------ | -------------------------------- |
| **Hardware**       | Dispositivos físicos (CPU, GPU, disco, USB)            | —                                |
| **Kernel**         | Controla o hardware e abstrai recursos                 | Gerencia processos e drivers     |
| **/sys (sysfs)**   | Exibe os dispositivos e módulos ativos                 | `/sys/class/net/`, `/sys/block/` |
| **/proc (procfs)** | Exibe o estado dos processos e parâmetros do kernel    | `/proc/cpuinfo`, `/proc/uptime`  |
| **udev**           | Lê o `/sys` e cria nós de dispositivos reais em `/dev` | `/dev/sda`, `/dev/ttyUSB0`       |
| **/dev**           | Interface concreta entre programas e hardware          | `/dev/null`, `/dev/random`       |
| **User Space**     | Onde rodam os programas e comandos                     | `cat`, `top`, `systemctl`, etc.  |

---

## ✅ **Resumo técnico final**

> O `/proc` e o `/sys` são **interfaces virtuais mantidas pelo kernel**, refletindo em tempo real o estado do sistema.
> O `udev` usa o `/sys` para identificar dispositivos e criar os correspondentes em `/dev`.
> Assim, `/proc`, `/sys` e `/dev` formam a **ponte entre o kernel e o espaço do usuário**, permitindo que comandos, serviços e aplicações interajam com o hardware sem precisar acessar o kernel diretamente.

---

Perfeito 🔥 — agora chegamos à **visão completa do ecossistema Linux moderno**, mostrando **como o kernel, `/proc`, `/sys`, `/dev`, `udev`, `systemd`, `modprobe` e `dbus` interagem** para formar o sistema operacional vivo e funcional.

A ideia é te dar uma **visão arquitetônica de alto nível**, mas ainda **precisa e técnica**, de como as camadas se comunicam — do hardware até os serviços de usuário.

---

# 🧭 **Arquitetura Viva do Linux Moderno**

*(interação entre Kernel, /proc, /sys, /dev, udev, systemd, modprobe e dbus)*

```
┌──────────────────────────────────────────────────────────────┐
│                  💻 HARDWARE FÍSICO                           │
│──────────────────────────────────────────────────────────────│
│ CPU | GPU | Memória | Discos | USB | Rede | Sensores etc.    │
└──────────────────────────────────────────────────────────────┘
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                      🧠 KERNEL LINUX                        │
│────────────────────────────────────────────────────────────│
│ - Núcleo do sistema operacional                             │
│ - Gerencia CPU, memória, I/O e drivers                      │
│ - Controla processos e isolamento (PID, namespaces, cgroups)│
│ - Expõe informações e interfaces através de:                │
│     📂 /proc → Processos e parâmetros do kernel              │
│     📂 /sys  → Dispositivos, módulos e subsistemas           │
│                                                          │
│  🔹 Módulos (drivers) carregados dinamicamente via:         │
│     → modprobe / insmod                                     │
│                                                          │
│  🔹 Kernel envia eventos "uevent" ao espaço do usuário      │
│     → Notifica criação/remoção de dispositivos              │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                ⚙️ UDEV / systemd-udevd                      │
│────────────────────────────────────────────────────────────│
│ - Daemon do espaço do usuário (PID > 1)                    │
│ - Escuta eventos do kernel via netlink                     │
│ - Lê árvore de dispositivos do /sys                        │
│ - Aplica regras (rules.d) e cria nós em:                   │
│       📂 /dev → /dev/sda, /dev/ttyUSB0, /dev/null          │
│ - Define permissões, nomes e grupos dos dispositivos        │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                🧩 SYSTEMD (PID 1 - init moderno)            │
│────────────────────────────────────────────────────────────│
│ - Primeiro processo do espaço do usuário                   │
│ - Garante montagem de /proc, /sys, /dev, /run, /tmp        │
│ - Inicializa udevd e outros daemons                        │
│ - Controla serviços via unidades (service, socket, target) │
│ - Usa DBus internamente p/ comunicação entre serviços       │
│ - Invoca modprobe p/ carregar módulos conforme necessidade  │
│ - Monitora dependências e supervisiona processos            │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                 🔌 MODPROBE / KMOD                          │
│────────────────────────────────────────────────────────────│
│ - Ferramentas de carregamento dinâmico de módulos           │
│ - `modprobe`: carrega módulo e dependências                │
│ - `rmmod`: remove módulo manualmente                       │
│ - Usado pelo kernel, systemd e udev conforme necessidade    │
│                                                          │
│ Ex:                                                        │
│   modprobe nvidia                                          │
│   modprobe bluetooth                                       │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│                  🗨️ DBUS (Barramento de Mensagens)           │
│────────────────────────────────────────────────────────────│
│ - Middleware de comunicação entre processos (IPC)          │
│ - Permite troca segura de mensagens entre serviços          │
│ - Usado por systemd, NetworkManager, udisks2, etc.          │
│ - Facilita automação e coordenação                         │
│                                                          │
│ Ex:                                                        │
│   - systemd notifica loginctl ou journalctl                │
│   - GNOME, KDE e outros desktop services via dbus          │
──────────────────────────────────────────────────────────────
                                │
                                ▼
──────────────────────────────────────────────────────────────
│             👤 ESPAÇO DO USUÁRIO / USER SPACE               │
│────────────────────────────────────────────────────────────│
│ - Shells, programas e daemons                              │
│ - Utilizam /proc, /sys e /dev p/ obter ou enviar info      │
│ - Comunicação indireta com o kernel                        │
│                                                          │
│ Exemplo de interações:                                    │
│   cat /proc/meminfo   → lê info de memória                 │
│   ls /sys/class/net/  → vê interfaces de rede              │
│   echo 1 > /sys/.../power/control → ativa modo energia     │
│   systemctl start nginx.service → ativa serviço via systemd│
│   dbus-send ... → comunicação IPC                          │
──────────────────────────────────────────────────────────────
```

---

## 🧩 **Fluxo de comunicação resumido**

```
[Hardware]
   │
   ▼
[KERNEL]
   ├── /proc → status e parâmetros
   ├── /sys  → dispositivos e módulos
   └── eventos uevent → notifica o espaço do usuário
         │
         ▼
[udevd] lê /sys → cria /dev
         │
         ▼
[systemd] supervisiona, inicia serviços, usa dbus
         │
         ▼
[User Space] → interage via /dev, lê /proc e /sys
```

---

## 🧠 **Visão hierárquica de responsabilidade**

| Camada         | Responsável     | Papel principal                         | Comunicação com quem                      |
| -------------- | --------------- | --------------------------------------- | ----------------------------------------- |
| **Kernel**     | Núcleo          | Gerencia hardware, memória, processos   | /proc, /sys, uevent                       |
| **/proc**      | Kernel          | Expor processos e parâmetros            | User Space                                |
| **/sys**       | Kernel          | Expor dispositivos, módulos e atributos | udev / User Space                         |
| **udev**       | User Space      | Cria /dev dinamicamente                 | Lê /sys, responde ao kernel               |
| **/dev**       | Kernel + udev   | Interface real com hardware             | Aplicações                                |
| **systemd**    | Init            | Coordena o sistema, gerencia serviços   | kernel, udev, dbus                        |
| **modprobe**   | Kernel helper   | Carrega/remover módulos                 | Chamado por systemd/udev                  |
| **dbus**       | Middleware IPC  | Comunicação entre serviços              | systemd, user apps                        |
| **User Space** | Usuários / Apps | Utiliza todos os recursos               | Interage com kernel via /proc, /sys, /dev |

---

## ✅ **Resumo técnico final**

> O Linux moderno é uma **arquitetura em camadas**, onde o **kernel é o centro**, e tudo acima dele se organiza para traduzir o acesso ao hardware em interfaces seguras, dinâmicas e automatizadas.
>
> * `/proc` e `/sys` são **as janelas do kernel**.
> * `udev` observa o `/sys` e **cria os dispositivos em `/dev`**.
> * `systemd` **coordena a orquestração do sistema**, chamando `modprobe` quando drivers precisam ser carregados.
> * `dbus` **fornece a comunicação entre processos e serviços** no espaço do usuário.
>
> Tudo isso junto forma o que chamamos de **“ecossistema vivo do Linux”**, onde kernel e user space cooperam de forma contínua e dinâmica.

---

# 🧩 **Fluxo Abstrato Universal — Detecção e Gerenciamento de Dispositivos no Linux**

Excelente colocação 👏 — e perfeito o seu cuidado metodológico: você quer **o esqueleto conceitual universal**, não um caso particular (como o pendrive).

✅ **Sim**: o *workflow* que mencionei serve para **qualquer dispositivo físico ou virtual** reconhecido pelo kernel — pendrives, placas de rede, GPUs, webcams, controladores de RAID, interfaces seriais, etc.
A diferença entre eles está apenas **nas “regras” e “ações específicas”** (por exemplo, montar um sistema de arquivos no caso de um pendrive, ou inicializar o `NetworkManager` no caso de uma placa de rede).

A seguir, te mostro exatamente esse **modelo abstrato e generalizado** — o *esqueleto universal* de como o **kernel, udev, systemd e o espaço do usuário** se articulam para **detectar, registrar e disponibilizar qualquer dispositivo**.

```
┌────────────────────────────────────────────────────────────┐
│                    💻 HARDWARE / DISPOSITIVO                │
│ Exemplo genérico: qualquer periférico, controlador, driver │
│ (SATA, PCI, USB, NVMe, GPU, Bluetooth, etc.)               │
└────────────────────────────────────────────────────────────┘
                               │
                               ▼
────────────────────────────────────────────────────────────
│                 🧠 KERNEL LINUX (ESPAÇO DE KERNEL)          │
│────────────────────────────────────────────────────────────│
│ 1️⃣  O dispositivo sinaliza sua presença via barramento:    │
│     → PCIe, USB, SATA, I2C, SPI, virtio, etc.               │
│                                                            │
│ 2️⃣  O kernel detecta o evento e tenta associar um driver.  │
│     → Usa tabelas internas de correspondência (ID tables).  │
│     → Pode carregar módulo automaticamente via modprobe.    │
│                                                            │
│ 3️⃣  Se o driver é carregado:                               │
│     - Ele cria uma representação do dispositivo no /sys     │
│       (por ex: /sys/class/net/eth0 ou /sys/block/sda)       │
│     - O kernel emite um “uevent” (netlink broadcast).       │
│       Exemplo: “add@/devices/pci0000:00/.../usb1/1-1”       │
────────────────────────────────────────────────────────────
                               │
                               ▼
────────────────────────────────────────────────────────────
│                ⚙️  UDEV / systemd-udevd (USER SPACE)        │
│────────────────────────────────────────────────────────────│
│ 4️⃣  O daemon udevd escuta os eventos uevent do kernel.     │
│     - Analisa o conteúdo (tipo, nome, IDs, classe, driver). │
│     - Consulta regras em /etc/udev/rules.d/ e /lib/udev/rules.d/│
│                                                            │
│ 5️⃣  Udev aplica as regras:                                 │
│     - Cria o nó correspondente em /dev                      │
│       Ex: /dev/sda, /dev/ttyUSB0, /dev/nvme0n1              │
│     - Define permissões, grupos, e nomes simbólicos         │
│     - Pode executar ações (scripts, systemctl, modprobe)    │
│                                                            │
│   Exemplo genérico de regra:                               │
│     ACTION=="add", SUBSYSTEM=="usb", RUN+="/usr/bin/script" │
────────────────────────────────────────────────────────────
                               │
                               ▼
────────────────────────────────────────────────────────────
│                  🧩 SYSTEMD (OU OUTROS DAEMONS)             │
│────────────────────────────────────────────────────────────│
│ 6️⃣  Systemd recebe notificações (via udev ou dbus).        │
│     - Pode acionar unidades do tipo “.device” ou “.service” │
│     - Ex: systemd monta partições, ativa rede, inicia Xorg. │
│                                                            │
│ 7️⃣  Pode também carregar módulos adicionais (modprobe)      │
│     - Ex: “modprobe nvidia”, “modprobe bluetooth”           │
│     - Ou iniciar serviços dependentes do novo hardware.     │
────────────────────────────────────────────────────────────
                               │
                               ▼
────────────────────────────────────────────────────────────
│               🧠 ESPAÇO DO USUÁRIO (USER SPACE)             │
│────────────────────────────────────────────────────────────│
│ 8️⃣  O dispositivo agora tem interfaces disponíveis:         │
│     - /dev/<dispositivo> → comunicação direta com driver     │
│     - /sys/class/... → atributos configuráveis (sysfs)      │
│     - /proc/... → informações de estado geral               │
│                                                            │
│ 9️⃣  Aplicações, shells e serviços usam essas interfaces:   │
│     - `mount /dev/sda1 /mnt`                               │
│     - `ip link set eth0 up`                                │
│     - `bluetoothctl`, `nvidia-smi`, `ffplay /dev/video0`   │
│                                                            │
│ 🔟  O ciclo é reversível: ao remover o dispositivo,          │
│     o kernel gera “remove@” → udev apaga o /dev → systemd   │
│     encerra serviços associados.                            │
────────────────────────────────────────────────────────────
```

---

## 🧠 **Resumo conceitual (nível mais abstrato possível)**

| Etapa | Camada              | O que acontece                                   | Exemplos de ação                   |
| ----- | ------------------- | ------------------------------------------------ | ---------------------------------- |
| ①     | Hardware            | Dispositivo aparece no barramento                | Inserção de USB, inicialização PCI |
| ②     | Kernel              | Detecta, associa driver e cria entrada em `/sys` | Carrega módulo via modprobe        |
| ③     | Kernel → User Space | Envia evento (uevent) para o espaço do usuário   | add@, remove@, change@             |
| ④     | Udev                | Recebe evento, aplica regras e cria `/dev/...`   | /dev/sda, /dev/ttyUSB0             |
| ⑤     | Systemd / Daemons   | Reagem ao novo nó, iniciam serviços              | mount, NetworkManager, etc.        |
| ⑥     | User Space          | Programas usam o dispositivo                     | leitura, escrita, configuração     |
| ⑦     | Kernel              | Gerencia o uso e libera recursos ao final        | remove@ → udev limpa o /dev        |

---

## 🔍 **O mesmo modelo vale para qualquer tipo de dispositivo**

| Tipo de Dispositivo | Subsystem (sysfs) | Nó em `/dev`   | Exemplo de ação automática   |
| ------------------- | ----------------- | -------------- | ---------------------------- |
| Pendrive / Disco    | block             | /dev/sda       | Montagem automática          |
| GPU                 | drm / pci         | /dev/dri/card0 | Driver gráfico inicializado  |
| Interface de Rede   | net               | /dev/eth0      | NetworkManager ativa conexão |
| Webcam              | video4linux       | /dev/video0    | Servidor de vídeo disponível |
| Bluetooth           | btusb             | /dev/hci0      | Serviço bluetoothd iniciado  |
| Controlador Serial  | tty               | /dev/ttyUSB0   | Login serial permitido       |

---

## ✅ **Resumo final refinado**

> Todo dispositivo no Linux passa, conceitualmente, pelos mesmos estágios:
>
> 1. **Detecção** → kernel percebe o hardware.
> 2. **Associação** → kernel escolhe o driver adequado.
> 3. **Exposição** → `/sys` reflete a estrutura interna.
> 4. **Notificação** → kernel emite “uevent”.
> 5. **Materialização** → `udev` cria o nó em `/dev`.
> 6. **Orquestração** → `systemd` inicia serviços dependentes.
> 7. **Utilização** → o usuário ou programa usa o dispositivo.
> 8. **Remoção** → evento “remove” limpa os recursos.

Esse esqueleto é o **modelo mental universal** de detecção e integração de dispositivos no Linux moderno — e é o mesmo que a AWS, Google Cloud e Red Hat usam em nível de sistema base em seus hypervisors.

---

# 🧠 **Fluxo Instrumentado — Monitorando a “Vida” de um Dispositivo no Linux**

Perfeito 🔥 — agora vamos para o **nível de observação e depuração profissional**, isto é, como **enxergar e auditar em tempo real cada estágio do workflow de detecção de dispositivos** no Linux.

Esse mapa que vou te mostrar serve como **guia prático de instrumentação**, usado por administradores, engenheiros de kernel e profissionais de cibersegurança para **ver o que realmente acontece entre hardware, kernel, udev, systemd e user space.**

Vamos usar a mesma lógica conceitual anterior (independente do tipo de dispositivo — pode ser pendrive, GPU, placa de rede, etc.), mas agora com **os comandos correspondentes para observar e depurar cada estágio**.

---

## 🧩 1️⃣ — **Evento Físico → Kernel Detecta Hardware**

**O que acontece:**

* O dispositivo é conectado (USB, PCI, etc.);
* O kernel reconhece o barramento e associa um driver (se disponível);
* A entrada é criada em `/sys/devices/...`.

**Como observar:**

```bash
# Acompanhar mensagens do kernel em tempo real
sudo dmesg -w
```

💡 *Saída esperada (exemplo USB):*

```
[12345.6789] usb 1-2: new high-speed USB device number 3 using xhci_hcd
[12345.6900] usb 1-2: New USB device found, idVendor=0781, idProduct=5591
[12345.6901] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
```

📌 **Dica:**
Aqui é onde você verifica se **o kernel detectou o hardware fisicamente**.
Se nada aparecer em `dmesg`, o kernel **nem soube que o hardware existe** (erro elétrico, barramento, BIOS ou firmware).

---

## ⚙️ 2️⃣ — **Kernel cria estrutura no `/sys`**

**O que acontece:**

* O kernel cria um diretório sob `/sys/class/` ou `/sys/devices/` para o novo dispositivo.
* Atributos e arquivos de controle surgem (modo energia, nome, status etc.).

**Como observar:**

```bash
ls /sys/class/ | sort
# ou para um dispositivo específico:
tree /sys/class/net/eth0
```

💡 *Aqui você enxerga o dispositivo “dentro” da árvore do kernel.*

---

## 📡 3️⃣ — **Kernel emite “uevent” (netlink broadcast)**

**O que acontece:**

* O kernel manda um evento “add@...” para o espaço do usuário;
* Contém informações sobre tipo, caminho, driver, ID, etc.

**Como observar:**

```bash
sudo udevadm monitor --environment --udev
```

💡 *Saída típica:*

```
UDEV  [12345.7890] add /devices/pci0000:00/.../usb1/1-2 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/.../usb1/1-2
SUBSYSTEM=usb
DEVNAME=/dev/sdb
DRIVER=usb-storage
```

📌 **Esse é o ponto exato onde o kernel “avisa” o sistema que algo novo chegou.**

---

## 🧠 4️⃣ — **Udev processa o evento**

**O que acontece:**

* O `udevd` recebe o evento do kernel;
* Aplica regras (`/etc/udev/rules.d/` e `/lib/udev/rules.d/`);
* Cria o nó correspondente em `/dev`.

**Como observar e depurar:**

```bash
sudo udevadm info -a -p $(udevadm info -q path -n /dev/sdb)
```

💡 *Isso mostra todas as propriedades conhecidas do dispositivo.*

E para depurar regras sendo aplicadas:

```bash
sudo udevadm test /sys/class/block/sdb
```

📌 *Ideal para ver qual regra está criando ou nomeando o dispositivo.*

---

## 🧩 5️⃣ — **Udev cria o nó em `/dev`**

**O que acontece:**

* O arquivo de dispositivo (device node) é materializado em `/dev`;
* Ele é o canal real de comunicação com o driver no kernel.

**Como observar:**

```bash
ls -l /dev | grep sdb
```

💡 *Você verá algo como:*

```
brw-rw---- 1 root disk 8, 0 Oct  9 12:34 sdb
```

📌 O par “8,0” são **major/minor numbers**, usados pelo kernel para identificar o dispositivo internamente.

---

## 🧩 6️⃣ — **Systemd reage e executa ações automáticas**

**O que acontece:**

* Systemd pode detectar o novo nó (via udev ou dbus);
* Ele ativa unidades dependentes do dispositivo, como `.device`, `.mount` ou `.service`.

**Como observar:**

```bash
systemctl list-units --type=device
```

💡 *Exemplo:*

```
dev-sdb.device       loaded active plugged   SanDisk_USB_Device
sys-devices-...sdb.device loaded active plugged   USB_STORAGE
```

📌 Aqui você vê **a integração entre systemd e udev** — é o nível onde o sistema operacional “ganha consciência” do novo hardware.

---

## 🗨️ 7️⃣ — **DBus e outros daemons reagem (nível desktop/server)**

**O que acontece:**

* Serviços como `udisks2`, `NetworkManager`, `bluetoothd`, `logind` e `upower` escutam DBus;
* Quando recebem notificações (via systemd-udevd ou dbus), executam ações automáticas.

**Como observar:**

```bash
dbus-monitor --system
```

💡 *Exemplo de evento real:*

```
signal sender=:1.23 -> dest=(null destination) serial=45 path=/org/freedesktop/UDisks2/drives/USB_DISK;
interface=org.freedesktop.DBus.Properties; member=PropertiesChanged
```

📌 *Aqui o desktop, automontagem e políticas de segurança reagem.*

---

## 🧠 8️⃣ — **Usuário / Aplicações utilizam o dispositivo**

**O que acontece:**

* O dispositivo agora está completamente disponível para uso;
* O usuário, o sistema ou aplicativos interagem com ele via `/dev`, `/sys` e `/proc`.

**Como observar (exemplos genéricos):**

```bash
# Ver detalhes de um bloco
lsblk -f

# Ver informações via procfs
cat /proc/partitions

# Manipular diretamente
cat /dev/input/event0 | hexdump -C
```

---

## 🔁 9️⃣ — **Remoção do dispositivo**

**O que acontece:**

* O kernel detecta o “disconnect” físico;
* Gera `remove@` uevent;
* Udev deleta o nó em `/dev`;
* Systemd e DBus finalizam serviços dependentes.

**Como observar:**

Continue rodando:

```bash
sudo udevadm monitor --udev
```

💡 Você verá:

```
UDEV [12346.1111] remove /devices/pci0000:00/.../usb1/1-2 (usb)
ACTION=remove
```

---

# 🧱 **Resumo Final — Mapa de Depuração (em uma tabela só)**

| Etapa | Camada         | Evento               | Como Monitorar                       | Exemplo de Saída         |
| ----- | -------------- | -------------------- | ------------------------------------ | ------------------------ |
| 1     | Kernel         | Detecção física      | `dmesg -w`                           | “new USB device found”   |
| 2     | Kernel         | Criação em `/sys`    | `tree /sys/class/...`                | Estrutura do dispositivo |
| 3     | Kernel → udev  | uevent (add@)        | `udevadm monitor`                    | ACTION=add               |
| 4     | udev           | Aplicação de regras  | `udevadm test`                       | Regras executadas        |
| 5     | udev           | Criação em `/dev`    | `ls -l /dev`                         | Nó criado                |
| 6     | systemd        | Ativação de unidades | `systemctl list-units --type=device` | dev-sdb.device           |
| 7     | DBus / Daemons | Notificações IPC     | `dbus-monitor --system`              | signal sender=:1.x       |
| 8     | User Space     | Uso real             | `lsblk`, `cat /proc/...`             | Dispositivo ativo        |
| 9     | Kernel         | Remoção              | `udevadm monitor --udev`             | ACTION=remove            |

---

## ✅ **Conclusão**

> Esse fluxo é o **esqueleto observável universal do Linux moderno**:
> Cada evento físico ou virtual percorre o mesmo pipeline — kernel → udev → systemd → user space —
> e você pode **monitorar, auditar e reagir** a cada passo usando os comandos correspondentes.

Com esse mapa, você não só entende **como o Linux “pensa” os dispositivos**, mas também domina o **ponto de intervenção certo para cada tipo de diagnóstico** — seja um pendrive, uma GPU NVIDIA ou uma interface de rede.

---

# ⚙️ **Interceptação e Reação Automática a Eventos de Dispositivos (udev + systemd)**

Perfeito 😎 — agora chegamos à camada **ativa e reativa do sistema Linux**, onde você não apenas **observa** o que acontece, mas **intercepta e reage automaticamente** a eventos de hardware em tempo real.

Essa abordagem é usada em automação de servidores, sistemas embarcados, data centers, segurança e até em setups de GPU ou IoT.

Vamos construir esse conhecimento de forma didática e **abstrata**, de modo que o mesmo modelo sirva para qualquer tipo de dispositivo.

---

## 🧩 1️⃣ — Conceito central: *“Reagir a um evento do kernel”*

Quando o **kernel detecta** um dispositivo (ou sua remoção), ele emite um evento chamado **uevent**.
Esse evento é recebido pelo daemon **udevd**, que lê suas **regras configuradas** e decide o que fazer.

Você pode “interceptar” esse momento criando uma **regra udev customizada**, que executa uma ação (script, comando, systemctl etc.) sempre que algo específico acontece.

---

## 🧱 2️⃣ — Estrutura geral de uma regra do udev

As regras ficam normalmente em:

```
/etc/udev/rules.d/
```

O formato básico de uma regra é:

```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="xxxx", ATTR{idProduct}=="yyyy", RUN+="/usr/local/bin/meu_script.sh"
```

**Significado:**

* `ACTION` → tipo de evento: `add`, `remove`, `change`
* `SUBSYSTEM` → categoria: `usb`, `block`, `net`, `pci`, etc.
* `ATTR{}` → atributo lido do `/sys`
* `RUN+=` → comando a executar quando a regra é satisfeita

---

## 🧠 3️⃣ — Exemplo abstrato universal (para qualquer dispositivo)

Crie o arquivo:

```bash
sudo nano /etc/udev/rules.d/99-dispositivo-generico.rules
```

E adicione:

```bash
# Reage à adição de qualquer dispositivo novo
ACTION=="add", RUN+="/usr/local/bin/on_device_add.sh"

# Reage à remoção de qualquer dispositivo
ACTION=="remove", RUN+="/usr/local/bin/on_device_remove.sh"
```

Agora crie os scripts correspondentes:

```bash
sudo mkdir -p /usr/local/bin
sudo nano /usr/local/bin/on_device_add.sh
```

Conteúdo:

```bash
#!/bin/bash
logger "📦 [udev] Dispositivo detectado: DEVNAME=$DEVNAME, SUBSYSTEM=$SUBSYSTEM, ACTION=$ACTION"
```

E o de remoção:

```bash
#!/bin/bash
logger "❌ [udev] Dispositivo removido: DEVNAME=$DEVNAME, SUBSYSTEM=$SUBSYSTEM, ACTION=$ACTION"
```

Dê permissão de execução:

```bash
sudo chmod +x /usr/local/bin/on_device_*.sh
```

E recarregue as regras do udev:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

---

## 🔍 4️⃣ — Como verificar se as regras estão funcionando

Execute:

```bash
sudo journalctl -f
```

Agora, **insira ou remova qualquer dispositivo** (pode ser USB, placa, etc.).
Você verá algo como:

```
Oct 09 14:45:03 host kernel: usb 1-2: new high-speed USB device number 5 using xhci_hcd
Oct 09 14:45:03 host root: 📦 [udev] Dispositivo detectado: DEVNAME=/dev/sdb, SUBSYSTEM=block, ACTION=add
```

💡 *Essas mensagens vêm diretamente do seu script via `logger` (que escreve no syslog / journalctl).*

---

## 🔁 5️⃣ — Integração com systemd (nível avançado)

Você pode fazer com que o **systemd** seja acionado automaticamente quando o evento ocorre, em vez de rodar scripts diretos.

### Exemplo: criar uma *unit* que inicia quando o dispositivo `/dev/sdb` aparece

**1️⃣ Crie uma regra udev:**

```bash
sudo nano /etc/udev/rules.d/99-disco.rules
```

Conteúdo:

```
KERNEL=="sdb", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="meu-servico@%k.service"
```

**2️⃣ Crie a unit systemd:**

```bash
sudo nano /etc/systemd/system/meu-servico@.service
```

Conteúdo:

```ini
[Unit]
Description=Serviço reativo para o dispositivo %i
After=dev-%i.device

[Service]
Type=oneshot
ExecStart=/usr/local/bin/on_device_detected.sh %i
```

**3️⃣ Crie o script chamado:**

```bash
sudo nano /usr/local/bin/on_device_detected.sh
```

Conteúdo:

```bash
#!/bin/bash
logger "🛰️ systemd: dispositivo %1 detectado, executando rotina personalizada..."
```

Dê permissão:

```bash
sudo chmod +x /usr/local/bin/on_device_detected.sh
```

**4️⃣ Recarregue as regras e o systemd:**

```bash
sudo udevadm control --reload-rules
sudo systemctl daemon-reload
```

Agora, ao inserir o dispositivo correspondente, o **systemd executará o serviço automaticamente.**

---

## ⚡ 6️⃣ — Ferramentas úteis de depuração

| Objetivo                   | Ferramenta / Comando                     | O que faz                                   |
| -------------------------- | ---------------------------------------- | ------------------------------------------- |
| Ver regras ativas do udev  | `udevadm info -a -p /sys/class/...`      | Mostra atributos e regras aplicáveis        |
| Simular evento manualmente | `udevadm trigger --verbose --action=add` | Reexecuta regras como se o evento ocorresse |
| Ver eventos em tempo real  | `udevadm monitor --udev --kernel`        | Mostra o pipeline completo                  |
| Ver logs dos scripts       | `journalctl -f`                          | Exibe logs em tempo real                    |
| Testar regra específica    | `udevadm test /sys/class/...`            | Debuga execução de regra                    |

---

## 🧱 7️⃣ — Estrutura lógica do ciclo reativo (visão geral)

```
┌───────────────────────────┐
│      DISPOSITIVO NOVO     │
└─────────────┬─────────────┘
              │
              ▼
        [KERNEL DETECTA]
              │
              ▼
         Emite uevent
              │
              ▼
        [UDEV RECEBE EVENTO]
              │
              ▼
   ↳ Aplica regra correspondente
              │
              ▼
 [Executa script OU ativa unidade systemd]
              │
              ▼
 [Ação automatizada: log, montagem, alerta, etc.]
```

---

## 🧠 8️⃣ — Aplicações práticas reais

| Caso de uso | Ação automatizada possível                             |
| ----------- | ------------------------------------------------------ |
| Segurança   | Logar toda conexão USB e enviar alerta                 |
| Servidor    | Montar discos externos automaticamente                 |
| HPC / GPU   | Carregar driver NVIDIA e inicializar monitor de uso    |
| IoT         | Reiniciar daemon de leitura de sensores quando plugado |
| Diagnóstico | Registrar timestamp de cada detecção física            |

---

## ✅ **Resumo conceitual**

> O udev é o elo que permite **responder de forma automatizada aos eventos do kernel**.
> Ele atua como um “gatekeeper” entre o kernel e o user space, permitindo acionar scripts, serviços e notificações.
>
> Quando combinado com o **systemd**, o Linux torna-se um sistema **reativo e autônomo**, capaz de responder a qualquer mudança de hardware em tempo real.

---

# 🛡️ Exemplo completo: “Monitor e bloqueio inteligente de USB”

Excelente 🔥 — agora a gente vai dar um salto e montar um **exemplo prático de automação reativa com segurança**, integrando três camadas poderosas do Linux:

* **udev** → detecta eventos físicos (kernel space → user space)
* **systemd** → executa e gerencia a ação reativa com isolamento
* **dbus / notify-send** → emite alertas para o usuário ou log remoto

## 🎯 Objetivo

Toda vez que **um novo dispositivo USB for conectado**, o sistema:

1. **Registra o evento no log** (via `logger`);
2. **Exibe uma notificação visual** para o usuário (ou envia alerta remoto);
3. **Opcionalmente bloqueia o dispositivo** se ele for “não autorizado”.

---

## 🧩 1️⃣ Criando uma regra do udev

Crie o arquivo:

```bash
sudo nano /etc/udev/rules.d/90-usb-monitor.rules
```

Conteúdo:

```bash
# Reage à conexão de QUALQUER dispositivo USB
ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", \
  TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-monitor@%k.service"
```

> 💡 `%k` representa o nome do dispositivo (por exemplo, `1-2`, `2-1.4`, etc.)

---

## 🧱 2️⃣ Criando o serviço systemd reativo

Crie o arquivo:

```bash
sudo nano /etc/systemd/system/usb-monitor@.service
```

Conteúdo:

```ini
[Unit]
Description=Monitoramento reativo de USB (%i)
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/usb_react.sh %i
```

Recarregue o `systemd`:

```bash
sudo systemctl daemon-reload
```

---

## ⚙️ 3️⃣ Criando o script de reação

Crie o arquivo:

```bash
sudo nano /usr/local/bin/usb_react.sh
```

Conteúdo:

```bash
#!/bin/bash
DEVICE_ID="$1"
LOG_TAG="[USB_MONITOR]"

# Extrai informações detalhadas do dispositivo
INFO=$(udevadm info --query=all --name=/dev/$DEVICE_ID 2>/dev/null | grep -E 'ID_MODEL=|ID_VENDOR=')

# Loga o evento
logger "$LOG_TAG Dispositivo USB detectado ($DEVICE_ID): $INFO"

# Envia notificação visual (se ambiente gráfico disponível)
if command -v notify-send >/dev/null 2>&1; then
    notify-send "🔌 Novo USB detectado" "Dispositivo: $DEVICE_ID"
fi

# Lista de dispositivos proibidos (por Vendor ID ou Product ID)
BLOCKLIST=("ID_VENDOR_ID=abcd" "ID_VENDOR_ID=1234")

for BAD_ID in "${BLOCKLIST[@]}"; do
    if echo "$INFO" | grep -q "$BAD_ID"; then
        logger "$LOG_TAG 🚫 Dispositivo bloqueado: $BAD_ID"
        # Desativa o dispositivo
        echo "1" | sudo tee "/sys/bus/usb/devices/$DEVICE_ID/authorized" >/dev/null
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "🚫 USB Bloqueado" "Dispositivo com ID proibido: $BAD_ID"
        fi
    fi
done
```

Dê permissão:

```bash
sudo chmod +x /usr/local/bin/usb_react.sh
```

---

## 🔍 4️⃣ Testando o sistema

Recarregue as regras:

```bash
sudo udevadm control --reload-rules
```

Ative o monitoramento:

```bash
sudo udevadm monitor --kernel --udev
```

Agora, **insira um dispositivo USB** — você verá algo como:

```
kernel: usb 1-2: new high-speed USB device number 7 using xhci_hcd
systemd[1]: Starting Monitoramento reativo de USB (1-2)...
root: [USB_MONITOR] Dispositivo USB detectado (1-2): ID_VENDOR=Kingston ID_MODEL=DataTraveler
```

E se for um dispositivo bloqueado:

```
root: [USB_MONITOR] 🚫 Dispositivo bloqueado: ID_VENDOR_ID=abcd
```

---

## 📡 5️⃣ Expansões avançadas

| Objetivo                                   | O que fazer                                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| **Enviar alerta remoto**                   | Adicione uma linha `curl -X POST` no script para enviar logs a um servidor                     |
| **Bloquear todos os USB de armazenamento** | Use uma regra `SUBSYSTEM=="block", ATTRS{busnum}=="1", RUN+="/usr/local/bin/block_storage.sh"` |
| **Gerar relatórios automáticos**           | Configure um cron job para coletar os logs `/var/log/syslog` com a tag `[USB_MONITOR]`         |
| **Ambiente corporativo**                   | Combine com `auditd` para rastrear inserções USB por usuário                                   |
| **Ambiente desktop**                       | Substitua `logger` por `zenity` ou `notify-send` para alertas visuais imediatos                |

---

## 🧠 6️⃣ Entendimento conceitual

Esse fluxo une três níveis do Linux:

```
┌──────────────────────────────┐
│   HARDWARE: USB plugado      │
└───────────────┬──────────────┘
                │
         [Kernel gera evento uevent]
                │
                ▼
         [udev recebe e aplica regras]
                │
                ▼
       [systemd ativa serviço reativo]
                │
                ▼
   [Script executa lógica de segurança]
        (log, notificação, bloqueio)
```

---

## ✅ Resumo prático

| Camada                       | Função                                                         |
| ---------------------------- | -------------------------------------------------------------- |
| **Kernel**                   | Detecta e reporta o evento físico (uevent)                     |
| **udev**                     | Traduz o evento em uma ação lógica                             |
| **systemd**                  | Gerencia a execução do serviço                                 |
| **Script / notify / logger** | Implementa a ação personalizada (registrar, alertar, bloquear) |

---

Perfeito 😎 — agora vamos construir a **versão defensiva completa**, pensada como um **módulo de segurança corporativa autônomo**, 100% com ferramentas nativas do Linux, sem depender de software proprietário.

Essa versão vai **proibir automaticamente o uso de dispositivos USB de armazenamento**, enquanto **permite periféricos legítimos** (como teclado, mouse, webcam etc.), **logando e alertando** qualquer tentativa de uso indevido.

---

# 🧱 **Arquitetura geral: “USB Guardian”**

### Objetivo:

> **Bloquear automaticamente pendrives e HDs externos**, mas **permitir dispositivos de entrada**, registrando e notificando todas as tentativas de conexão.

---

## ⚙️ 1️⃣ Estrutura conceitual do sistema

```
┌────────────┐
│ Kernel     │ ← Evento físico (“USB conectado”)
└─────┬──────┘
      │
      ▼
[udev rule] → Intercepta o evento
      │
      ▼
[systemd unit] → Executa o script reativo
      │
      ▼
[usb_guardian.sh]
  ├─ Verifica tipo do dispositivo
  ├─ Bloqueia se for de armazenamento
  ├─ Loga evento no syslog
  ├─ Envia alerta remoto (opcional)
```

---

## 🧩 2️⃣ Regra udev para interceptar todos os USBs

Crie o arquivo:

```bash
sudo nano /etc/udev/rules.d/91-usb-guardian.rules
```

Conteúdo:

```bash
# Reage à adição de QUALQUER dispositivo USB
ACTION=="add", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", \
  TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-guardian@%k.service"
```

---

## 🧱 3️⃣ Serviço systemd reativo

Crie:

```bash
sudo nano /etc/systemd/system/usb-guardian@.service
```

Conteúdo:

```ini
[Unit]
Description=USB Guardian Security Monitor (%i)
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/usb_guardian.sh %i
```

Recarregue:

```bash
sudo systemctl daemon-reload
```

---

## 🧠 4️⃣ Script de segurança principal

Crie:

```bash
sudo nano /usr/local/bin/usb_guardian.sh
```

Conteúdo completo:

```bash
#!/bin/bash
DEVICE_ID="$1"
LOG_TAG="[USB_GUARDIAN]"
SYS_PATH="/sys/bus/usb/devices/$DEVICE_ID"

# Extrai informações do dispositivo
VENDOR=$(cat "$SYS_PATH/idVendor" 2>/dev/null)
PRODUCT=$(cat "$SYS_PATH/idProduct" 2>/dev/null)
CLASS=$(cat "$SYS_PATH/bDeviceClass" 2>/dev/null)
DEVTYPE=$(udevadm info -a -p "$SYS_PATH" | grep "bInterfaceClass" | head -n1 | awk -F'==' '{print $2}' | xargs)

logger "$LOG_TAG Dispositivo conectado: ID_VENDOR=$VENDOR ID_PRODUCT=$PRODUCT CLASS=$CLASS INTERFACE=$DEVTYPE"

# Função para bloquear o dispositivo
block_device() {
    echo "0" > "$SYS_PATH/authorized"
    logger "$LOG_TAG 🚫 Dispositivo USB BLOQUEADO: ID=$VENDOR:$PRODUCT"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "🚫 USB BLOQUEADO" "Dispositivo ID $VENDOR:$PRODUCT"
    fi
    # Envio remoto opcional
    curl -s -X POST -H "Content-Type: application/json" \
      -d "{\"event\":\"usb_blocked\",\"vendor\":\"$VENDOR\",\"product\":\"$PRODUCT\",\"host\":\"$(hostname)\"}" \
      http://192.168.1.100:8080/usb-logs >/dev/null 2>&1
}

# Permite apenas dispositivos de HID (classe 03) → teclado/mouse
if [[ "$CLASS" == "03" ]]; then
    logger "$LOG_TAG ✅ Dispositivo HID permitido ($VENDOR:$PRODUCT)"
    exit 0
fi

# Bloqueia classes comuns de armazenamento (08)
if [[ "$CLASS" == "08" ]]; then
    block_device
    exit 0
fi

# Bloqueia se ID estiver em lista proibida
BLOCKLIST=("1a2b" "abcd" "1234")

for BAD_ID in "${BLOCKLIST[@]}"; do
    if [[ "$VENDOR" == "$BAD_ID" ]]; then
        block_device
        exit 0
    fi
done

# Caso não se encaixe em nenhum critério, apenas loga
logger "$LOG_TAG ℹ️ Dispositivo USB permitido (não crítico): ID=$VENDOR:$PRODUCT"
```

Permissão:

```bash
sudo chmod +x /usr/local/bin/usb_guardian.sh
```

---

## 🔍 5️⃣ Ativando e testando

Recarregue o udev:

```bash
sudo udevadm control --reload-rules
```

Ative o monitoramento:

```bash
sudo journalctl -f
```

Conecte um **pendrive** → você deverá ver algo como:

```
kernel: usb 1-3: new high-speed USB device number 9 using xhci_hcd
root: [USB_GUARDIAN] Dispositivo conectado: ID_VENDOR=0781 ID_PRODUCT=5567 CLASS=08
root: [USB_GUARDIAN] 🚫 Dispositivo USB BLOQUEADO: ID=0781:5567
```

Conecte um **teclado USB** → deve aparecer:

```
root: [USB_GUARDIAN] ✅ Dispositivo HID permitido (046d:c31c)
```

---

## 🧩 6️⃣ Componente opcional: servidor remoto de logs

Você pode criar um endpoint simples em outro servidor para armazenar logs:

```bash
# Exemplo em Python (Flask)
from flask import Flask, request
app = Flask(__name__)

@app.route('/usb-logs', methods=['POST'])
def log_usb():
    data = request.json
    print(f"[ALERTA USB] Host={data['host']} Vendor={data['vendor']} Product={data['product']}")
    return {"status": "ok"}, 200

app.run(host='0.0.0.0', port=8080)
```

Assim, qualquer tentativa de pendrive indevido é **registrada centralmente**.

---

## 🧩 7️⃣ Camadas de defesa adicionais

| Camada                  | Descrição                                                     |
| ----------------------- | ------------------------------------------------------------- |
| **Kernel / udev**       | Bloqueia fisicamente o acesso ao dispositivo (`authorized=0`) |
| **systemd**             | Garante execução isolada, sem depender de sessão de usuário   |
| **logger / syslog**     | Registra evento localmente                                    |
| **notify-send / D-Bus** | Emite alerta visual imediato                                  |
| **HTTP POST (curl)**    | Envia log remoto para centralização corporativa               |

---

## ⚙️ 8️⃣ Resumo conceitual

```
┌──────────────┐
│  Kernel USB  │
└──────┬───────┘
       │
       ▼
[udev rule ➜ usb-guardian.service]
       │
       ▼
[usb_guardian.sh]
   ├─ Verifica classe / ID
   ├─ Loga tentativa
   ├─ Bloqueia se for indevido
   ├─ Alerta usuário / servidor remoto
```

---

## ✅ Benefícios

✅ Zero dependência externa — tudo com ferramentas nativas
✅ Execução automática e reativa
✅ Segurança preventiva contra vazamento via USB
✅ Integração fácil com SIEM ou syslog remoto
✅ Extensível para PCI, rede ou Bluetooth

---

Se quiser, posso te montar **uma segunda versão aprimorada**, chamada “**USB Guardian v2 — modo corporativo**”, que adiciona:

* logs criptografados com hash SHA256,
* whitelisting dinâmico (permitir pendrives autorizados),
* e integração com `auditd` para rastrear o usuário logado que tentou o acesso.

