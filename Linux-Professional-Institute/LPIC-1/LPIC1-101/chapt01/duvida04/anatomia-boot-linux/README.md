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