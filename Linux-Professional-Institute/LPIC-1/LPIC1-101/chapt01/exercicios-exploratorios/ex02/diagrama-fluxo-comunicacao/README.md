# **Diagrama completo do fluxo de comunicação**

Excelente — então bora montar esse mapa detalhado 🧠🔥

O que você vai ver agora é **a anatomia completa do fluxo de comunicação entre o hardware, o kernel e o espaço de usuário**, que explica **como o Linux descobre e monta `/sys/bus`, associa drivers e cria os dispositivos em `/dev`**.

Isso é um dos pilares pra entender **como o kernel fala com o mundo físico (ou virtual)**.
Vamos por etapas, em nível crescente de abstração 👇

---

## 🧩 1. Nível Físico — Hardware e Barramentos

Quando o computador liga, o **firmware (BIOS/UEFI)** inicializa os barramentos físicos e entrega ao kernel informações básicas sobre o hardware conectado:

```
[Hardware físico]
 ├── CPU
 ├── Memória RAM
 ├── Barramentos:
 │    ├── PCI / PCIe → GPUs, NICs, controladoras
 │    ├── USB        → periféricos externos
 │    ├── SATA / NVMe → discos
 │    ├── I²C / SPI  → sensores, GPIO, SoCs ARM
 │    ├── virtio     → dispositivos virtuais (em VMs)
 │    └── ...
 └── Firmware (BIOS/UEFI) → informa tabela de dispositivos ao kernel
```

Cada barramento define **como os dispositivos são descobertos e endereçados**.
Por exemplo:

* PCI: usa **endereços de barramento/dispositivo/função (BDF)**;
* USB: usa **árvore hierárquica de hubs**;
* I²C: usa **endereçamento direto** de dispositivos simples.

---

## ⚙️ 2. Nível Kernel — Montagem de `/sys` e Descoberta

Logo no boot, o **initramfs** e o **kernel** executam a sequência:

```
mount -t sysfs sysfs /sys
mount -t proc  proc  /proc
```

Esses dois pseudo–sistemas de arquivos são **janelas para dentro do kernel**:

* `/proc` → mostra **processos**, **memória**, **configurações de runtime**;
* `/sys`  → mostra **dispositivos**, **drivers**, **barramentos** e **classes**.

### Dentro de `/sys`:

```
/sys
 ├── bus/          → cada barramento detectado (pci, usb, i2c, scsi...)
 ├── class/        → agrupamento por função (net, block, input...)
 ├── devices/      → todos os dispositivos do sistema (hierarquia física)
 ├── block/        → discos e partições
 └── module/       → módulos carregados
```

O kernel preenche esses diretórios dinamicamente conforme detecta o hardware.

---

## 🧠 3. Associação de Drivers ↔ Barramentos

O kernel mantém uma **tabela de associação (binding)** entre:

* o **barramento** (ex: PCI),
* o **dispositivo detectado** (ex: placa de rede Intel),
* e o **driver compatível** (ex: `e1000e`).

Fluxo lógico:

```
[PCI bus] detecta dispositivo → [kernel] procura driver compatível
 → driver registra funções → cria entrada em /sys/bus/pci/drivers/
 → dispositivo aparece em /sys/devices/pci...
```

Cada driver exporta **atributos e interfaces** para o `/sys`, que podem ser lidos/modificados pelo usuário ou pelo `udev`.

---

## 🔁 4. Udev — Do Kernel ao Espaço do Usuário

Quando um novo dispositivo aparece (por exemplo, você pluga um pendrive USB):

1. O kernel gera um **evento uevent**:

   ```
   add@/devices/pci0000:00/.../usb1/1-1
   ACTION=add
   DEVPATH=/devices/...
   SUBSYSTEM=block
   DEVNAME=sdb
   DEVTYPE=disk
   ```

2. O daemon **`systemd-udevd`** escuta esses eventos.

3. Ele aplica regras em `/etc/udev/rules.d/` e `/lib/udev/rules.d/`:

   * Define **nome de dispositivo** (ex: `/dev/sdb`);
   * Define **permissões**;
   * Executa scripts personalizados (ex: montar automaticamente um disco, carregar módulo etc.).

4. Por fim, ele cria o **arquivo de dispositivo em `/dev`**, que é um **nó especial** apontando para o driver no kernel.

---

## 🧭 5. Fluxo Geral — Do Hardware até `/dev`

```
[Firmware/BIOS/UEFI]
        ↓
[Kernel detecta barramentos]
        ↓
[/sys/bus/* → representação do barramento]
        ↓
[Driver é associado ao dispositivo]
        ↓
[Kernel emite evento "uevent"]
        ↓
[systemd-udevd interpreta e aplica regras]
        ↓
[/dev/xxx criado → acesso pelo usuário]
```

Exemplo com pendrive:

```
/sys/bus/usb/devices/1-2/ (kernel detecta)
  ↓
uevent → udev → /dev/sdb (criado)
```

Exemplo com GPU:

```
/sys/bus/pci/devices/0000:01:00.0/
  ↓
driver nouveau → /dev/dri/card0 (criado)
```

---

## 🧩 6. Visualização Resumida (Camadas do Sistema)

```
──────────────────────────────────────────────
│   ESPAÇO DO USUÁRIO (user space)           │
│--------------------------------------------│
│ /dev/ → acesso a dispositivos (udev)       │
│ systemd, udevd, ferramentas (lsusb, lspci) │
──────────────────────────────────────────────
│   ESPAÇO DO KERNEL                         │
│--------------------------------------------│
│ Drivers de dispositivos                    │
│ /sys/bus → barramentos                     │
│ /sys/devices → dispositivos descobertos    │
│ /proc → processos, memória, parâmetros     │
──────────────────────────────────────────────
│   HARDWARE / FIRMWARE                      │
│--------------------------------------------│
│ BIOS / UEFI / SoC                          │
│ Barramentos físicos (PCIe, USB, I²C...)    │
│ Dispositivos reais (CPU, GPU, disco, etc.) │
──────────────────────────────────────────────
```

---

## 💬 Conclusão

> O diretório `/sys` é o **espelho da topologia física do hardware e seus barramentos**,
> `/proc` é o **espelho do estado interno do kernel e dos processos**,
> e `/dev` é o **ponto de entrada para o usuário acessar dispositivos reais**.
>
> Tudo isso é costurado dinamicamente por `udev`, que traduz o que o kernel descobre em interfaces usáveis.

---
