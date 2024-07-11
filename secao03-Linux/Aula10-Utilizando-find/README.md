# Utilizando o FIND:
- find - Serve para procurar um arquivo. Até aqueles que estão ocultos.

- find /(nome do diretório) - vai mostrar tudo que está dentro desse diretório.

- find -type (f ou d) - filtra a procura por tipos, sendo "f" arquivos e "d" diretórios.

- find -type f -name "(nome do arquivo e extensão dela)" - Serve para verficar se existe o arquivo com aquele nome. Diferencia letra maiúscula e minúscula. O mesmo vale para diretório, caso coloque o "d" no lugar de "f".

- findo -type f -name "(siglas)*" - serve para procurar todos os arquivos que inicia com a tal sigla. O mesmo vale para o diretório caso coloque o "d" no lugar de "f".

## Referencias

    https://www.geeksforgeeks.org/find-command-in-linux-with-examples/