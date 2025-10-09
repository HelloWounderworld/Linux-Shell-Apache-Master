# Exercício 01

Suponha que um sistema operacional não consegue inicializar após um segundo disco SATA ser adicionado ao sistema. Sabendo que as peças não são defeituosas, qual poderia ser a causa possível desse erro?

## Resposta

### Resposta antiga, mas certa

Visto que as pecas nao estao com defeitos, provavelmente, o problema esta nos passos de inicializacao da BIOS, no sentido das ordens de prioridades estarem errados ou nao na sua inicializacao.

### Resposta aprimorada

Visto que as peças não apresentam defeitos físicos, uma causa provável é a alteração da ordem de inicialização configurada na BIOS/UEFI após a adição do segundo disco SATA.

Quando um novo disco é conectado, o firmware pode automaticamente redefinir as prioridades de boot, fazendo o sistema tentar iniciar a partir do disco recém-adicionado (que não possui um sistema operacional ou um bootloader válido).

Em sistemas que utilizam identificadores baseados em nomes de dispositivos (ex.: /dev/sda, /dev/sdb), a inserção de um novo disco também pode mudar o mapeamento desses nomes, resultando em falha na localização da partição de boot.

Soluções típicas: revisar a ordem de boot na BIOS/UEFI, garantir que o disco correto esteja definido como primário, e, se necessário, ajustar o fstab ou o carregador de inicialização (GRUB) para usar UUIDs em vez de nomes de dispositivo — evitando esse tipo de conflito em futuras alterações de hardware.
