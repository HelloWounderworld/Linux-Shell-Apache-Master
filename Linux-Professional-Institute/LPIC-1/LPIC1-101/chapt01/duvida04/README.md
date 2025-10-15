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

- proc-pid

---

# 🧭 Anatomia do Boot Linux (com foco em `/proc` e `/sys`)

- anatomia-boot-linux

# 🧭 **Anatomia do Boot Linux — Diagrama de Montagem do `/proc` e `/sys`**

- anatomia-boot-linux-proc-sys

# 🧬 **Anatomia do Núcleo Vivo do Linux**

- anatomia-nucleo-vivo-linux

# 🧭 **Arquitetura Viva do Linux Moderno**

- arquitetura-viva-linux-moderno

# 🧩 **Fluxo Abstrato Universal — Detecção e Gerenciamento de Dispositivos no Linux**

- deteccao-gerenciamento-linux

# 🧠 **Fluxo Instrumentado — Monitorando a “Vida” de um Dispositivo no Linux**

- monitorando-vida-dispositivo-linux

# ⚙️ **Interceptação e Reação Automática a Eventos de Dispositivos (udev + systemd)**

- automatic-reaction-interceptor

# 🛡️ Exemplo completo: “Monitor e bloqueio inteligente de USB”

- block-usb

# 🧱 **Arquitetura geral: “USB Guardian”**

- usb-guardian

# ⚙ **C e Assembly**

- c-assembly
