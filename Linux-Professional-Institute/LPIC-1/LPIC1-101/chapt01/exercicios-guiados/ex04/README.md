# Exercício 04

Um administrador deseja experimentar parâmetros diferentes para o módulo do kernel "bluetooth" sem reiniciar o sistema. No entanto, qualquer tentativa de descarregar o módulo com "modprobe -r bluetooth" resulta no seguinte erro:

    modprobe: FATAL: Module bluetooth is in use.

Qual a possível causa desse erro?

## Resposta

### Resposta antiga, mas certa

Provavelmente, a causa do erro estaria no fato de o modulo kernel "bluetooth" ela estar ativa. No caso, poderia verificar pelo "dmesg" para disgnosticar o motivo dela estar ativa e, somente identificado algo ativo nela, daria para tentar desativar a funcionalidade dela pelo terminal para, somente depois disso, conseguir descarregar o modulo. Provavelmente, o modulo carregado, nao tem como ser descarregado, se o dispositivo em si, estiver em uso ou ativo.

### Resposta aprimorada

O erro ocorre porque o módulo de kernel “bluetooth” está atualmente em uso por outros processos ou módulos dependentes — por exemplo, o btusb, btrtl, bnep ou algum serviço do espaço de usuário (como o bluetoothd do BlueZ).

O kernel não permite descarregar um módulo que possua dependências ativas ou dispositivos vinculados, para evitar instabilidade no sistema.

Para diagnosticar a causa, o administrador pode verificar quais módulos dependem de bluetooth:

```Shell
lsmod | grep bluetooth
```

A coluna “Used by” indica quantos e quais módulos ou processos estão utilizando-o.

Também é possível verificar se o serviço Bluetooth está em execução:

```Shell
systemctl status bluetooth
```

Antes de tentar descarregar o módulo, é necessário:

Encerrar o serviço:

```Shell
sudo systemctl stop bluetooth
```

Remover os módulos dependentes, se ainda estiverem carregados:

```Shell
sudo modprobe -r btusb bnep btrtl
```

Só então tentar novamente:

```Shell
sudo modprobe -r bluetooth
```

Em resumo, o erro “Module bluetooth is in use” ocorre porque o módulo está ativo e sendo utilizado — o kernel impede sua remoção até que todos os dependentes e serviços associados sejam finalizados.
