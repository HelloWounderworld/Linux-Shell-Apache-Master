# **Pergunta**

> Agora, eu gostaria de saber o seguinte, sobre o bootloader. Eu soube que tais parametros abaixo, servem para manipular os kernels. Eu gostaria de saber se existe algum arquivo ou pasta onde esta listada todos esses tais parametros para verificar qual seria o padrao em que ela esta configurada?
>
>acpi
>
>init
>
>systemd.unit
>
>mem
>
>maxcpus
>
>quiet
>
>vga
>
>root
>
>rootflags
>
>ro
>
>rw

# **Resposta**

Ótima dúvida — é muito prática e útil para administrar e entender como o sistema é inicializado. Vou responder direto ao ponto: onde estão listados (e documentados) **os parâmetros de kernel / cmdline**, como ver o *valor atual*, onde definir o padrão no bootloader (GRUB / systemd-boot / EFI) e — para fechar — um mini-guia rápido com o **significado** das flags que você listou.

---

## 1) Onde ver a linha de boot atual (o que o kernel recebeu)

O *valor efetivo* passado ao kernel **neste boot** está em:

```bash
cat /proc/cmdline
```

Esse é o lugar definitivo para saber quais parâmetros o kernel recebeu nesta inicialização.

---

## 2) Onde os parâmetros estão documentados (lista completa / referência)

Os parâmetros do kernel são documentados no tree de documentação do próprio kernel. Em um sistema com os headers/documentação instalada, procure por:

* `/usr/src/linux/Documentation/admin-guide/kernel-parameters.rst`
  ou (formatos antigos)
* `/usr/src/linux/Documentation/kernel-parameters.txt`

Se sua distro fornece pacotes de doc, procure em:

* `/usr/share/doc/linux-doc/Documentation/admin-guide/kernel-parameters.rst`
  ou similar.

Se não tiver localmente, a referência oficial é a página do kernel (kernel.org) — **“kernel parameters”** (procure *Documentation/admin-guide/kernel-parameters* no código fonte).

**Comando prático** para procurar localmente (se documentação instalada):

```bash
grep -R "kernel parameter" /usr/src/linux*/Documentation -n 2>/dev/null || true
# ou
zgrep -i "kernel parameters" /usr/share/doc/* -n 2>/dev/null || true
```

> Nota: essa documentação lista **todos** os parâmetros, sintaxes (`mem=`, `maxcpus=`, etc.) e o que cada um faz.

---

## 3) Onde fica a configuração padrão usada pelo bootloader (onde editar)

Depende do bootloader:

### GRUB (a mais comum)

* Arquivo com opções globais:

  ```text
  /etc/default/grub
  ```

  A variável é `GRUB_CMDLINE_LINUX` (ou `GRUB_CMDLINE_LINUX_DEFAULT`).

* Depois de editar, gere o `grub.cfg`:

  ```bash
  sudo update-grub      # Debian/Ubuntu
  # ou
  sudo grub2-mkconfig -o /boot/grub2/grub.cfg   # RHEL/CentOS/Fedora
  ```

* O grub final (o que efetivamente passa a linha para kernel) está em:

  ```text
  /boot/grub/grub.cfg   # ou /boot/grub2/grub.cfg
  ```

  (não edite esse arquivo manualmente; gere via update-grub/grub2-mkconfig).

### systemd-boot (bootctl / loader entries)

* Entradas individuais:

  ```text
  /boot/loader/entries/*.conf
  ```

  Ex.: em cada arquivo `.conf` há uma linha `options root=/dev/… quiet` — edite aí para alterar cmdline daquela entrada.

### EFI/Direct kernel (efistub)

* Parâmetros configurados por `efibootmgr` ou pelo gerenciador; são armazenados em NVRAM. Ferramentas e localização variam.

### Distribuições RHEL/CentOS (grubby)

* Use `grubby --args` para adicionar parâmetros para todos os kernels ou para um kernel específico.

---

## 4) Como ver quais parâmetros um driver/module aceita (parâmetros de módulos)

Parâmetros passados ao kernel na linha `cmdline` são diferentes dos *module parameters* (que você passa para drivers com `modprobe param=valor`).
Para ver parâmetros de um módulo:

```bash
modinfo -p nome_do_modulo
# ou
modinfo nome_do_modulo
```

---

## 5) Resumo — onde procurar e comandos úteis

* **Valor atual**: `cat /proc/cmdline`
* **Docs completos (kernel)**: `Documentation/admin-guide/kernel-parameters*` no source tree ou `/usr/share/doc` da distro
* **Editar padrão GRUB**: `/etc/default/grub` → editar `GRUB_CMDLINE_LINUX*` → `sudo update-grub`
* **systemd-boot**: `/boot/loader/entries/*.conf` (linha `options`)
* **Ver módulos/params**: `modinfo`, `sysfs` em `/sys/module/<mod>/parameters/`
* **Procurar menção a um parâmetro**:

  ```bash
  grep -R "mem=" /usr/src/linux*/Documentation -n 2>/dev/null || true
  ```

---

## 6) Significado rápido das flags que você listou

Vou dar uma definição curta e prática de cada uma (o comportamento exato pode variar com versão do kernel):

* `acpi=` — controla opções do ACPI. Exemplos: `acpi=off`, `acpi=ht`, `acpi=force`. Afeta gerenciamento de energia, tabelas ACPI.
* `init=` — define o *init* a executar como PID 1 (ex: `init=/bin/bash` para debug).
* `systemd.unit=` — instrução ao systemd para iniciar outro *unit/target* (ex: `systemd.unit=rescue.target`).
* `mem=` — limita a memória visível para o kernel (ex: `mem=512M` ou `mem=4G@1G`). Útil para teste/compatibilidade.
* `maxcpus=` — limita número de CPUs que o kernel ativa (ex: `maxcpus=1`).
* `quiet` — reduz mensagens do kernel no boot (silencia printk).
* `vga=` — parâmetros antigos para modo de vídeo (legado VESA/ framebuffer; hoje em dia usa `video=` ou KMS).
* `root=` — especifica o dispositivo raiz (ex: `root=/dev/sda2` ou `root=UUID=...`).
* `rootflags=` — flags de montagem para o root fs (ex: `rootflags=data=writeback` para ext4?; uso depende do filesystem/mount options suportadas).
* `ro` / `rw` — monta o filesystem root como read-only (`ro`) ou read-write (`rw`) inicialmente.

> Para cada um, a documentação do kernel descreve sintaxe completa, valores possíveis e efeitos colaterais.

---

## 7) Exemplo prático — ver, alterar, testar

1. Ver cmdline atual:

   ```bash
   cat /proc/cmdline
   ```

2. Alterar parâmetro no GRUB (ex.: adicionar `quiet`):

   * Edite `/etc/default/grub`, adicione `quiet` a `GRUB_CMDLINE_LINUX_DEFAULT`.
   * Atualize o grub:

     ```bash
     sudo update-grub
     ```
   * Reboot para aplicar (algumas mudanças só entram após reboot; outras, como `systemd.unit=`, também requerem reboot).

3. Teste temporário (no GRUB menu):

   * Ao iniciar, edite a entrada no GRUB (pressione `e`) e modifique a linha `linux` adicionando o parâmetro; bootará sem alterar configs permanentes.

---

## 8) Observações / dicas finais

* **`/proc/cmdline`** é sempre a fonte de verdade do que o kernel recebeu.
* **Leia a documentação do kernel** para a lista completa de parâmetros; há dezenas (mem, video, dma, iommu, numa, isolcpu, nohz, mitigations, etc.).
* **Cuidado** ao mexer em parâmetros críticos (`ro`, `root=`, `init=`, `acpi=`, `maxcpus=`) — podem deixar o sistema não bootável. Sempre teste em ambiente controlado.
* Para *provisionamento automático* em servidores, edite o arquivo de entrada do bootloader (GRUB, systemd-boot) via automação (Ansible/Terraform) em vez de editar `grub.cfg` diretamente.

---

Se quiser eu:

* te jogo o **comando que localiza no teu sistema os docs** exatos (`kernel-parameters`) e imprime a seção `mem`/`acpi`/`init` para você (posso gerar o comando pronto); **ou**
* **explico detalhadamente cada um** dos parâmetros da sua lista com exemplos de uso e riscos (mais verboso);
