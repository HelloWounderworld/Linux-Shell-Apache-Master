# Identificar e editar configurações de hardware

Anotacoes das duvidas que eu tirei com o chat conforme a abordagem do assunto.

## Introdução

- duvida01

### Ativação do dispositivo

### Inspeção de dispositivos no Linux

#### Comandos para inspeção

- lspci

        lspci

        lspci -s <ID> -v

        lspci -s <ID> -k

        lspci -nn

- lsusb

        lsusb
        
        lsusb -d <ID>

        lsusb -v -d <ID>

        lsusb -t

        lsusb -s <Bus:Dev>

        lsusb -v -s <Bus:Dev>

- kmod

        lsmod

        lsmod | fgrep -i <Module Name>

- modprobe

        modprobe -r <Module Name> # Be careful, this command will stop a kernel module process

        sudo modprobe <nome_do_modulo> # Carregando manualmente o modulo

        sudo insmod /path/to/driver.ko # Caso o arquivo .ko estiver fora dos caminhos padrão

- modinfo

        modinfo -p <Module Name> # When you'd like to check every information about a specific module

- duvida02

### Arquivos de informação e de dispositivo

- duvida03

### Dispositivos de armazenamento
