# Seção 06 - Filtro e buscas de arquivos e diretórios:

## Aula 01 - Introdução

## Aula 02 - Comando head
Primeiro, dentro da pasta Documents ou Documentos, vamos criar um arquivo documento.txt e na internet pesquisa algum link que faça um gerador de texto "Lorem" e dentro desse arquivo cole o texto de 50 parágrafos. Ao darmos

    cat documento.txt

Será exibido pelo terminal todo o conteúdo do arquivo.

Mas tem casos em que vc não quer ver o conteúdo inteiro dentro dela, mas, sim, só uma parte inicial dela, então para isso que temos o head

    head documento.txt

Isso exibirá somente o começo do conteúdo dentro desse texto.

Podemos tbm colocar a quantidade de linhas que vc quer que seja exibido

    head -n n (nome do arquivo).(extensão)

donde "n" acima é algum número natural não nulo.

Podemos usar o head, também para mandarmos o conteúdo de uma linha para um outro arquivo, mesmo que esse arquivo não exista

    head -n 1 documento.txt > documento2.txt

Basta olhar o que tem dentro do documento2.txt, e caso esse arquivo não exista, ele é criado no processo acima.

## Aula 03 - Comando tail
Já o tail é como se fosse o inverso do head, pois vc consegue ver uma parte do final do conteúdo do arquivo.

    tail documento.txt

No caso, as mesmas funcionalidades de head que vimos acima tbm serve para tail.

Mas, agora, existe uma funcionalidade do tail que é o que os desenvolvedores mais utilizam dele

    tail -f (nome do arquivo).(extensão)

No caso, o comando acima é muito utilizado para conseguirmos conferir os arquivos log tem tempo real, pois cada alteração que ocorrer e, real time, será exibido ao abrirmos o arquivo pelo "tail -f" e ficarmos parado olhando o arquivo aberto por esse comando.

Basta clicar em Ctrl + c para sairmos dessa aplicação.

## Aula 04 - Comando grep

## Aula 05 - Comando find

## Aula 06 - Comando locate

## Aula 07 - Dica: executando o último comando novamente

## Aula 08 - Dica: de onde os comandos são executados
