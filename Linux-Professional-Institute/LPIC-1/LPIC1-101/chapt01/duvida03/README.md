# 📌 Estrutura típica do `udev` em Linux nativo

## 1. Diretórios principais

1. **`/etc/udev/`**

   * Local para **regras definidas pelo administrador**.
   * Subdiretório principal:

     * `/etc/udev/rules.d/` → aqui ficam as regras personalizadas do sistema (ex.: criar symlink em `/dev` quando plugar um dispositivo USB).
   * Prioridade: regras aqui **sobrescrevem** as regras padrão de `/lib/udev`.

---

2. **`/lib/udev/`** (ou em alguns sistemas `/usr/lib/udev/`)

   * Contém as **regras padrão fornecidas pelos pacotes do sistema**.
   * Exemplos:

     * `/lib/udev/rules.d/` → regras principais que definem comportamento padrão (montagem de disco, permissão de USB, etc.).
     * Programas auxiliares (`scsi_id`, `ata_id`, etc.), usados para coletar informações de hardware.

---

3. **`/run/udev/`**

   * Diretório **dinâmico de runtime**, criado em tempo de execução.
   * Usado para:

     * Armazenar informações temporárias sobre dispositivos ativos.
     * Gerenciar eventos que o daemon `systemd-udevd` recebe do kernel.
   * Esse diretório é **volátil**: some ao reiniciar o sistema.

---

## 2. Onde fica o daemon

* O daemon que processa tudo é o **`systemd-udevd`**.
* Ele é iniciado pelo `systemd` (nas distros modernas).
* Binário geralmente está em:

  ```bash
  /usr/lib/systemd/systemd-udevd
  ```

  ou

  ```bash
  /lib/systemd/systemd-udevd
  ```

---

## 3. Resumindo por distro

* **Ubuntu / Debian**

  * `/etc/udev/rules.d/` → regras do administrador.
  * `/lib/udev/rules.d/` → regras padrão.
  * `/run/udev/` → runtime.

* **Red Hat / CentOS / Fedora**

  * Mesma lógica, mas em versões mais novas a Canonical e a Red Hat migraram parte do conteúdo de `/lib/udev` para **`/usr/lib/udev/`**, seguindo a hierarquia FHS moderna.
  * Ou seja: em sistemas baseados em RHEL recentes, você verá `/usr/lib/udev/rules.d/` em vez de `/lib/udev/rules.d/`.

---

# 📌 Resumindo em uma frase sólida

**Em um Linux real (Ubuntu, Red Hat, etc.), o `udev` organiza-se em `/etc/udev/` (regras do administrador), `/lib/udev/` ou `/usr/lib/udev/` (regras padrão do sistema) e `/run/udev/` (estado dinâmico em tempo de execução), com o daemon `systemd-udevd` ativo processando eventos do kernel.**

---
