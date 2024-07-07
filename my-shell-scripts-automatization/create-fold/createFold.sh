#!/bin/bash

# Para dar a permissão de execução desse script, digite no terminal
# chmod +x nome_do_arquivo_script.sh

# Para remover a permissão seria
# chmod -x nome_do_arquivo_script.sh

# Nome da pasta a ser criada
echo "Digite o nome da pasta que deseja criar"
# pasta = "nome_da_pasta"
read pasta

# Verifica se a pasta existe ou não existe antes de criar
if [ ! -d "$pasta" ]; then
    mkdir "$pasta"
    echo "Pasta '$pasta' criada com sucesso!"
else
    echo "A pasta, '$pasta', já existe"
fi # Esse "fi" é uma sintaxe que fecha um bloco que iniciou com uma condicional "if"
