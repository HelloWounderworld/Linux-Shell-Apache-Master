# Exercício 02

Você acaba de adquirir um novo computador de mesa e gostaria de conferir se a placa de vídeo externa conectada ao barramento PCI é realmente a anunciada pelo fabricante. Porém, se abrir o gabinete do computador, a garantia será anulada. Qual comando pode ser usado para listar as informações da placa de vídeo detectadas pelo sistema operacional?

## Resposta

### Resposta antiga, mas certa

Poderia ser utilizada o seguinte comando:

    lspci

Assim, poderia ser verificado as informacoes da placa de video.

### Resposta aprimorada

Para verificar as informações da placa de vídeo conectada ao barramento PCI sem abrir o gabinete, pode-se utilizar o comando:

    lspci

Esse comando lista todos os dispositivos PCI detectados pelo sistema operacional, incluindo placas de vídeo, controladores de rede e outros periféricos.

Para filtrar apenas as informações relacionadas à GPU, pode-se usar:

    lspci | grep -i vga

ou, para obter detalhes mais completos sobre o dispositivo:

    lspci -v -s $(lspci | grep -i vga | cut -d" " -f1)

Dessa forma, é possível confirmar o modelo e o fabricante da placa de vídeo (por exemplo, NVIDIA, AMD ou Intel) sem precisar abrir o gabinete e, portanto, sem comprometer a garantia do equipamento.
