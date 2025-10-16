# Exercício Exploratório 03

Muitos roteadores de rede incluem uma porta USB que permite a conexão de um dispositivo externo, como um disco rígido USB. Sabendo que a maioria deles usa um sistema operacional baseado em Linux, qual seria o nome de um disco rígido USB externo no diretório "/dev/", supondo-se que não haja nenhum outro dispositivo de bloco convencional no roteador?

## Resposta

### Resposta antiga

sda

### Resposta aprimorada

Os kernels do Linux modernos identificam os discos rígidos USB como dispositivos SATA, de modo que o arquivo correspondente será /dev/sda, já que não existe nenhum outro dispositivo de bloco convencional no sistema.

- identificacao-device
