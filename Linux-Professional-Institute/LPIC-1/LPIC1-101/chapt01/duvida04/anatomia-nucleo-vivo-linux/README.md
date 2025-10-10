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
