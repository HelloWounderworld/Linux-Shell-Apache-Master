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