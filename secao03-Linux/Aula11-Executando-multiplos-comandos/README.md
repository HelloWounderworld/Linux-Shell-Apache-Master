# Execudando multiplos comandos:

## Utilizando ";"
Voce pode separar varios comandos usando ";"

    comando1; comando2; comando3;

O ponto aqui seria que o conjunto de comandos acima, idependentemente se algum deles derem errado, ira prosseguir ate que seja feito o ultimo comando.

## Utilizando &&
O operador "&&" e o "and" lido de esquerda para direita.

    comando1 && comando2 && comando3

A sequencia de comando acima seria que o comando2 so sera executado mediante ao comando1 executado e terminado com sucesso e assim sucessivamente.

## Utilizando ||
O operador "||" e o "or" lido de esquerda para direita

    comando1 || comando2 || comando3

Ou seja, o comando2, so sera acionado, se o comando1 der errado. Enquanto o comando1 der certo, o processo ira terminar nisso.

## Utilizando ()
Usando o parenteses "()" para agrupar um conjunto de comandos

    (comando1; comand2) && (comando3; comando4)

## Utilizando subshells
Podemos definir, utilizando o parenteses acima, subshells, ou seja, separar cada comando que ela seja feita em diretorios diferentes

    (cd /tmp; ls -l)

Ou seja, o comando "ls -l" sera feito no diretorio /tmp, mesmo que o diretorio atual seja diferente.