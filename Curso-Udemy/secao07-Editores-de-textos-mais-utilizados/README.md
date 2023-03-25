# Seção 07 - Editores de texto mais utilizados:

## Aula 01 - Introdução

## Aula 02 - Nano: criando, salvando e saindo de arquivo
Primeiro vamos instalar o nano

    sudo apt-get install nano

Feito a instalação, podemos, então, utilizar o nano. No caso, para criarmos um arquino nano, bastaria digitar no terminal

    nano

Que ele, automaticamente, criará um arquivo vazio e abrirá para vc.

Bom, a forma de uso eu já sei, pois usei muito com estava configurando uma infra usando uma vm pelo cloud.

## Aula 03 - Nano: editando arquivo
Podemos usar o nano para copiar um arquivo dentro de outro.

Primeiro, usando o nano, vamos criar um outro arquivo testandonano2.txt e dentro dela colocamos "Olá Mundo". Em seguida, abrimos o arquivo testandonano.txt usando sudo nano e então fazemos o seguinte

    Ctrl + r

Em seguida, colocamos o nome do arquivo que criamos testandonano2.txt ou colocamos a path onde está o arquivo que queremos copiar o conteúdo, então ao darmos o enter, veremos que o conteúdo do outro arquvio estará concatenado com o contéudo do arquivo que abrimos.

Se quisermos que o conteúdo do outro arquivo seja concatenado em um lugar específico, bastaria direcionar o cursor até la.

## Aula 04 - Nano: copiando, colando e recortando conteúdo
Para copiar

    alt + 6

Podemos usar alt + (setinhas) para selecionar até o ponto em que queremos.

Para colar

    Ctrl + u

Para recortar

    Ctrl + k

## Aula 05 - Nano: movimentação dentro de arquivo
Ao abrirmos o arquivo e o mesmo tiver muito, mas muito, conteúdo e vc quer analisar a parte final dela e realizar algumas alterações. Para ir até o final bastaria apertar

    alt + / (barra)

Agora, do final, se vc quiser ir até o início do arquivo, bastaria apertar

    alt + \

Caso vc queira ir em algum linha em específico bastaria apertar

    alt + g

em seguida, vc digita o número da linha em que vc queira ir.

## Aula 06 - Nano: busca e replace
Para realizar alguma busca

    Ctrl + w

basta digitar a palavra ou alguma sentença que vc procura.

    Ctrl + w, Ctrl + v e Ctrl + y

para procurar a palavra e ir no final e, em seguida, ir no início.

Para substituir

    alt + r

Em seguida vc digita primeiro o conteúdo para procurar e tecla enter, em seguida, digita o valor pela qual vc queira substituir no lugar do conteúdo que foi digitado.

## Aula 07 - Vim: instalação e modos do editor
Primeiro vamos ter que instalar o vim

    sudo apt-get install vim

Feito a instalação, para abrir um arquivo vim com um nome bastaria fazer o seguinte

    vim (nome do arquivo).(extensão)

Vamos colocar vim arquivonovo.txt.

Bom, precisamos entender que o vim, diferentemente do nano, ele tem dois modos de funcionalidade. Ou seja, não podemos já ir realizando as alterações como no nano. Os dois modos que o vim tem é o de inserção e o de comandos. A alternância entre esses dois modos se dá pela tecla Enter.

No caso, deixando no modo de comando podemos apertar em seguida "i" e será exibido o modo de inserção "-- INSERT --".

Para sairmos de um modo, precisamos teclar "esc".

## Aula 08 - Vim: editando, salvando e fechando arquivo
Para salvar o arquivo e suas alterações para, em seguida, sair seria

    :x

Agora, para abrir novamente, é o mesmo que fizemos no início, o arquivo.

Agora, fizemos a edição e em seguida quero apenas salvar, mas sem sair do arquivo. Para isso

    :w

Se vc quer, simplesmente, sair do arquivo

    :q

Obs: sempre que estiver editando, ou seja, estiver no modo "-- INSERT --", antes de teclar qualquer comando acima, teria que teclar "esc" primeiro.

## Aula 09 - Vim: deletando linha, undo e redo
Para deletar uma linha

    dd

Bastaria digitar "d" duas vezes.

Refazer, dar o Ctrl + z, do que vc vez

    u (undo)

Isso mesmo, basta ir teclando "u" conforme a necessidade para voltar nas alterações que vc queria.

Se vc quiser fazer o reverso disso, Ctrl + Shift + z, então bastaria teclar

    Ctrl + r

## Aula 10 - Vim: search e replace
Para realizar uma busca

    /(digitar a palavra que vc quer buscar)

E vc pode ir dando "n" para ele ir localizando as palavras que vc estiver procurando ou vc poderia "shift + n".

Para substituir

    :%s/(busca palavra que vc quer substituir)/(palavra que irá substituir no lugar)

Se na linha onde está o cursor estiver a palavra que vc queira substituir bastaria fazer

    :s/(busca palavra que vc quer substituir)/(palavra que substituirá no lugar)

## Aula 11 - Dica: saindo sem salvar arquivo no Vim
Se quiser sair sem salvar seria

    :q!
