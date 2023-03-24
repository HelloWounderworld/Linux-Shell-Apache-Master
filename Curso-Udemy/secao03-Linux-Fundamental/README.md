# Seção 03 - Linux Fundamental:

## Aula 01 - Introdução

## Aula 02 - Conhecendo o terminal e o shell

## Aula 03 - Entendendo a estrutura de diretórios do Linux

## Aula 04 - Comando cd: básico

## Aula 05 - Comando cd: avançado
Se eu quiser chegar direto no usuário da home basta colocar

    cd ~

Uma outra forma avançada de usar o cd é descrevendo para ela a path com ../../diretorio, etc...

Outra coisa que vc pode fazer é usar o comando "cd" com a tecla tab. No caso, se vc colocar cd e mais um nome de algum diretório e vc não lembra complementamente, bastaria dar o tab para ele completar para vc.

Podemos concatenar os comandos usando o &&, por exemplo

    cd etc && ls

No caso, o que está acontecendo acima é que estou dizendo que quero ir para o diretório etc e, em seguida, listar o que tem dentro desse diretório.

## Aula 06 - Comando ls: básico

## Aula 07 - Comando ls: avançado
Podemos listar o que contém em um diretório sem necessidade de acessar o diretório

    ls /(nome do diretórios)

Serve tbm fazer

    ls -l /(nome do diretório)

Se vc quiser saber que tem de pastas em cada subdiretórios bastaria digitar
    
    ls -R

O comando 

    ls -l

Ele lista em ordem decrescente pelo tamanho dos arquivos ou pastas.

Se quiser que seja listado em ordem por vírgula, bastaria colocar o comando

    ls -m

Qualquer coisa se vc quiser saber tudo que tem de funcionalidade do ls bastaria colocar 

    ls --help

## Aula 08 - Comando clear

## Aula 09 - Comando cat: básico

## Aula 10 - Comando cat: avançado

## Aula 11 - Comando touch

## Aula 12 - Comando man
O comando "man" ele basicamente exibe o manual dos outros comandos. Um exemplo disso, seria vc colocar

    man ls

Isso irá exibir o manual inteiro de como poderia utilizar o ls.

## Aula 13 - Dica: buscando comandos com ctrl + r
No caso, caso vc quiser buscar os comandos que vc digitou no passado temos duas alternativas

- A primeira é vc ficar apertando o botão com a seta para cima

- A segunda é vc digitar Ctrl + r e nela vc colocar as iniciais do comando que vc quer digitar e, encontrado o comando, em seguida dar o enter.
