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