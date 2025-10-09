# **Debug avançado de módulos**

Perfeito 👌 — aqui vem a **parte avançada do diagnóstico de módulos de kernel**, voltada a cenários onde o driver **existe**, mas **não inicializa corretamente** (ou o kernel sequer tenta carregá-lo).

Essa parte cobre:

* diagnóstico de dependências e conflitos,
* uso do `depmod`, `modprobe` e `dkms`,
* reconstrução de módulos de terceiros,
* e como inspecionar logs de falha no carregamento.

---

## 🧩 1. Confirmar que o módulo está presente no sistema

```bash
find /lib/modules/$(uname -r) -type f -name "*.ko*" | grep nome_do_modulo
```

Se nada aparecer → o módulo não existe para esse kernel.
Verifique se há outro kernel instalado:

```bash
ls /lib/modules
```

Cada diretório representa um kernel instalado.
Você pode precisar atualizar para um kernel que inclua o driver desejado.

---

## ⚙️ 2. Recriar o índice de dependências (`depmod`)

O `depmod` gera os mapas que o `modprobe` usa para resolver dependências automáticas.

Execute:

```bash
sudo depmod -a
```

Depois, tente novamente:

```bash
sudo modprobe nome_do_modulo
```

Se funcionar após o `depmod`, o problema era apenas o índice desatualizado.

---

## 🔎 3. Listar dependências e símbolos do módulo

Para entender **por que um módulo falha ao carregar**, veja as dependências:

```bash
modinfo nome_do_modulo | grep depends
```

E verifique símbolos ausentes (causa comum de erro “Unknown symbol”):

```bash
sudo dmesg | grep nome_do_modulo
```

Saída típica:

```
nome_do_modulo: Unknown symbol usb_register_driver (err -2)
```

Isso significa que outro módulo (no caso, `usbcore`) precisa estar carregado antes.
→ Solução: use `modprobe` (que carrega dependências automaticamente), **não `insmod`**.

---

## 🧱 4. Forçar o carregamento em modo debug

Carregue o módulo com logging detalhado:

```bash
sudo modprobe nome_do_modulo dyndbg=+p
```

Se o módulo suportar *dynamic debug*, ele emitirá mensagens extras via `dmesg`.

---

## 🧰 5. Resolver falhas de assinatura (Secure Boot)

Em sistemas com **Secure Boot**, o kernel só carrega módulos assinados.
Se você compilou um módulo manualmente, ele pode ser rejeitado:

Verifique o log:

```bash
dmesg | grep -i "module signature"
```

Saída típica:

```
Lockdown: Loading of unsigned module is restricted; see man kernel_lockdown.7
```

Soluções possíveis:

* Desativar Secure Boot temporariamente no BIOS, **ou**
* Assinar manualmente o módulo:

```bash
sudo kmodsign sha512 MOK.priv MOK.der /path/to/modulo.ko
```

Depois registre a chave:

```bash
sudo mokutil --import MOK.der
```

E reinicie o sistema para confirmar o enrolamento da chave (MOK enrollment).

---

## 🧮 6. Verificar conflitos e drivers duplicados

Se o módulo correto não carrega, pode haver outro já associado ao mesmo dispositivo.

Liste o driver atual:

```bash
lspci -k | grep -A 3 "nome_do_dispositivo"
```

Se aparecer outro `Kernel driver in use: ...`, descarregue-o:

```bash
sudo modprobe -r driver_antigo
sudo modprobe driver_novo
```

Bloqueie o antigo para evitar recarga:

```bash
echo "blacklist driver_antigo" | sudo tee /etc/modprobe.d/blacklist-old-driver.conf
```

---

## 🧰 7. Quando o módulo é de terceiros — usar DKMS

**DKMS (Dynamic Kernel Module Support)** recompila módulos automaticamente quando o kernel é atualizado.

### a) Instalar o DKMS

```bash
sudo apt install dkms build-essential linux-headers-$(uname -r)
```

### b) Adicionar o módulo ao DKMS

Se o módulo está em `/usr/src/nomedodriver-x.y/`, faça:

```bash
sudo dkms add -m nomedodriver -v x.y
sudo dkms build -m nomedodriver -v x.y
sudo dkms install -m nomedodriver -v x.y
```

Depois verifique:

```bash
dkms status
```

### c) Reinstalar um módulo DKMS quebrado

```bash
sudo dkms remove -m nomedodriver -v x.y --all
sudo dkms install -m nomedodriver -v x.y
```

Assim o módulo será reconstruído para o kernel atual e para futuros upgrades.

---

## 🧩 8. Validar integridade e versão do módulo

Verifique se o módulo foi compilado para o kernel correto:

```bash
modinfo /path/to/modulo.ko | grep vermagic
uname -r
```

Se o `vermagic` não coincidir com o kernel em uso, ele **não será carregado**.
Solução: recompile o módulo com os *headers* do kernel atual.

---

## 🧠 9. Recompilando manualmente um módulo (quando não há DKMS)

Se você tem o código-fonte (`driver.c` e `Makefile`):

```bash
sudo apt install build-essential linux-headers-$(uname -r)
make
sudo insmod nome_do_modulo.ko
```

Para instalar permanentemente:

```bash
sudo cp nome_do_modulo.ko /lib/modules/$(uname -r)/extra/
sudo depmod -a
sudo modprobe nome_do_modulo
```

---

## 🧩 10. Logs detalhados e diagnóstico final

Use:

```bash
journalctl -k -b | grep nome_do_modulo
```

ou, para observar o carregamento em tempo real:

```bash
sudo dmesg -w
```

---

## ✅ Conclusão (fechada)

> Mesmo que o módulo exista, ele pode falhar ao inicializar por dependências ausentes, conflito, assinatura inválida, versão incorreta ou firmware ausente.
> As ferramentas-chave para diagnóstico são:
> **`modinfo`**, **`dmesg`**, **`depmod`**, **`lsmod`**, **`dkms`** e **`journalctl`**.
> Com `depmod` e `modprobe`, você garante dependências resolvidas; com DKMS e assinatura, garante compatibilidade e persistência.

---