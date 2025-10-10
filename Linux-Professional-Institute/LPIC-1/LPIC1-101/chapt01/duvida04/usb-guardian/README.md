# 🧱 **Arquitetura geral: “USB Guardian”**

Perfeito 😎 — agora vamos construir a **versão defensiva completa**, pensada como um **módulo de segurança corporativa autônomo**, 100% com ferramentas nativas do Linux, sem depender de software proprietário.

Essa versão vai **proibir automaticamente o uso de dispositivos USB de armazenamento**, enquanto **permite periféricos legítimos** (como teclado, mouse, webcam etc.), **logando e alertando** qualquer tentativa de uso indevido.

---

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