# Exercício Exploratório 03

Em 2018, a vulnerabilidade de hardware conhecida como Meltdown foi descoberta. Ela afeta quase todos os processadores de diferentes arquiteturas. As versões mais recentes do kernel Linux podem informar se o sistema atual está vulnerável. Como obter essas informações?

## Resposta

### Resposta antiga

Bastaria conferir pelo lsmod, lsusb ou lspci. Nas informacoes por meio de combinacoes de os recursos nelas exibidas como "-d, -s, -v, etc..." seria possivel identificar a vulnerabilidade dos dispositivos.

O arquivo /proc/cpuinfo tem uma linha que mostra os bugs conhecidos para a CPU correspondente, como por exemplo bugs: cpu_meltdown.

---

### 🧠 Avaliação da tua resposta

Excelente — essa é uma ótima pergunta, porque ela exige entender **a diferença entre vulnerabilidades de hardware (CPU)** e **dispositivos periféricos (PCI/USB)**, além de conhecer como o Linux expõe informações de segurança do kernel.

A tua resposta mostra uma boa intenção em usar comandos de inspeção de hardware (`lsmod`, `lsusb`, `lspci`), **mas o método em si não identifica vulnerabilidades de CPU como o *Meltdown*.**
Esses comandos mostram **módulos, barramentos e dispositivos**, mas **não expõem flags de segurança do processador nem mitigations aplicadas pelo kernel.**

Vamos destrinchar o ponto, e depois te mostro como melhorar tua resposta para o nível “robusto”.

#### ✅ Pontos positivos:

* Você identificou corretamente que é possível inspecionar o sistema por comandos do Linux.
* A menção de opções `-v`, `-s`, etc. mostra que você entende o uso de *flags* para detalhar dispositivos.

#### ❌ Pontos a corrigir:

* **Meltdown não é uma vulnerabilidade de dispositivo periférico (PCI, USB, etc.)**, mas de **microarquitetura de CPU** (execução especulativa e isolamento de memória de kernel).
* `lsmod`, `lspci`, `lsusb` não trazem informações sobre **vulnerabilidades mitigadas** no processador — eles mostram módulos e controladores.
* O Linux moderno tem **arquivos e comandos específicos** para isso, principalmente em `/sys/devices/system/cpu/vulnerabilities/`.

---

#### 🧩 Explicação correta — Como o Linux expõe essas informações

A partir do kernel **4.15+**, o Linux passou a incluir **mitigações de segurança para Meltdown e Spectre**, além de um mecanismo para o administrador verificar o status.

Você pode obter as informações com um simples comando:

```bash
cat /sys/devices/system/cpu/vulnerabilities/*
```

A saída mostrará algo assim:

```
/sys/devices/system/cpu/vulnerabilities/meltdown: Mitigation: PTI
/sys/devices/system/cpu/vulnerabilities/spectre_v1: Mitigation: usercopy/swapgs barriers and __user pointer sanitization
/sys/devices/system/cpu/vulnerabilities/spectre_v2: Mitigation: Full generic retpoline
/sys/devices/system/cpu/vulnerabilities/l1tf: Mitigation: PTE Inversion
```

Cada linha indica:

* **Qual vulnerabilidade** está sendo testada;
* **Se o sistema está vulnerável, mitigado ou não afetado.**

Se o sistema estiver vulnerável, verá algo como:

```
Vulnerable: PTI not applied
```

---

#### ⚙️ Alternativas complementares

Você também pode obter essas informações com:

##### 1️⃣ via `dmesg`:

```bash
dmesg | grep -i meltdown
```

Mostra as mensagens de inicialização do kernel relacionadas às mitigations aplicadas.

##### 2️⃣ via `lscpu`:

```bash
lscpu | grep -E 'Model name|Vulnerability'
```

Mostra o modelo do processador e, em versões recentes, flags de vulnerabilidade conhecidas.

##### 3️⃣ via ferramentas específicas:

* `spectre-meltdown-checker` — script oficial mantido pela comunidade que realiza verificações completas:

  ```bash
  sudo apt install spectre-meltdown-checker
  sudo spectre-meltdown-checker
  ```

---

#### 🧩 Versão aprimorada da tua resposta

O comando `lsmod`, `lsusb` e `lspci` são úteis para listar módulos, dispositivos e barramentos conectados, mas **não identificam vulnerabilidades de CPU como o Meltdown**.

Para verificar se o sistema está vulnerável, o kernel Linux mantém arquivos em:

```bash
/sys/devices/system/cpu/vulnerabilities/
```

Você pode conferir com:

```bash
cat /sys/devices/system/cpu/vulnerabilities/*
```

Cada arquivo indica se o sistema está vulnerável, protegido ou não afetado.
Alternativamente, pode-se usar:

```bash
dmesg | grep meltdown
```

ou

```bash
sudo spectre-meltdown-checker
```

Assim é possível saber, com base na configuração atual do kernel e do hardware, se as mitigações contra Meltdown (e outras vulnerabilidades de CPU) estão ativas.

---

#### 🧠 Conclusão

* **Meltdown** é uma vulnerabilidade **de CPU**, não de módulos periféricos.
* **Ferramenta correta:** `/sys/devices/system/cpu/vulnerabilities/`
* **Objetivo:** verificar se o kernel aplicou mitigations (PTI, retpoline, etc.).
* **Comandos como `lspci` ou `lsusb` não são adequados**, pois atuam em outro domínio (barramentos, não microarquitetura).

---

# **Vulnerabilidades de hardwares**

- vulnerabiliadades
