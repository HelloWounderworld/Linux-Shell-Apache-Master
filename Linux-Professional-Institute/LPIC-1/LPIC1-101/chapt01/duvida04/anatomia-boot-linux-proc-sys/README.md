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