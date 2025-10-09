# Exercício 03

A linha a seguir faz parte da saída gerada pelo comando lspci:

    03:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 [Thunderbolt]
    (rev 05)

Qual comando deve ser executado para identificar o módulo do kernel em uso neste dispositivo específico?

## Resposta

### Resposta antiga, mas certa

O comando para identificar o modulo kernel deste dispositivo eh

    lspci -s 03:00.0 -v

ou

    lspci -s 03:00.0 -k

### Resposta aprimorada

O comando a ser utilizado para identificar qual módulo de kernel (driver) está associado a um dispositivo PCI específico é:

```Shell
lspci -s 03:00.0 -k
```

A opção -s (slot) filtra a saída para o dispositivo localizado no endereço 03:00.0, enquanto a opção -k exibe as informações sobre os módulos do kernel utilizados e os módulos disponíveis para aquele dispositivo.

O comando abaixo também pode ser usado para obter informações detalhadas do dispositivo, incluindo recursos e interrupções, embora o foco principal não seja o módulo:

```Shell
lspci -s 03:00.0 -v
```

Em resumo, o -k é a opção mais direta para verificar qual driver o kernel está usando atualmente para um dispositivo PCI, como no exemplo:

```yaml
Kernel driver in use: megaraid_sas
Kernel modules: megaraid_sas
```
