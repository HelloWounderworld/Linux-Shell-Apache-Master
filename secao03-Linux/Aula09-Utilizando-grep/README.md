# Utilizando GREP

## Formato basico de utilizacao do grep
A sua forma basica e o seguinte

    grep '[search pattern]' [file_name]

### Exemplo:
Dentro do diretorio /var/log

    grep 'system' syslog

## Caso queira realizar a busca em mais arquivos
Bastaria acrescentar mais arquivos utilizando o espaco

    grep '[search pattern]' test1.txt test2.txt test3.txt

## Utilizando *
Podemos utilizar o "*" para indicar que estamos realizando busca sobre os arquivos que tenha tais iniciais

    grep '[search pattern]' [sigla]*

ou

    grep '[search pattern]' *

Somente o '*' sera feita uma varredura geral de todos os arquivos presentes no diretorio atual.

### Exemplo
Dentro do diretorio /var/log

    grep 'system' sys*

ou, de qualquer diretorio

    grep 'system' /var/log/sys*

Ira realizar a busca da palavra 'system' dentro de todos os arquivos que iniciem com a sigla 'sys'.

## Utilizando .
Podemos utilizar "." para realizar uma busca mais generalizada ainda sobre todos os arquivos do diretorio atual.

O ponto, ".", ele indica o diretorio atual em que sera feito a varredura.

    grep '[search pattern]' .

Porem ele retorna algum booleano.

### Exemplo
De qualquer diretorio

    grep 'system' .

## Acrescentando -i
Quando vc acrescenta "-i" esta sendo dito para tornar a busca em insensitive case

    grep -i 'system' .

ou 

    grep -i 'system' /var/log/syslog

## Acrescentando -r
Quando vc acrescenta "-r" esta sendo feito uma busca recursiva.

Pelo diretorio raiz "/"

    grep -r 'system' /var

ou

    grep -r 'system' /var/log

Sera feito uma busca da palavra "system" dos arquivos dentro do diretorio indicado para ate aos arquivos dos subdiretorio do diretorio indicado.

Podemos realizar a combinacao

    grep -i -r 'system' /var

Claro, o uso de tais acrescentos nao e algo restrito com o ".". Podemos usar sem o ponto tbm.

Podemos realizar uma busca mais poderosa.

Do diretorio raiz "/"

    grep -r 'system' *

Ou seja, sera feito uma varredura de busca dentro de todos os arquivos resididos no diretorio atual e dos subdiretorios presentes e, alem disso, isso sera feito de forma recursiva.

## Acrescentando -R
Quando vc acrescenta "-R" vc esta extendendo a busca recursiva para os links simbolocos tbm

    grep -R 'system' *

### Referencia para leitura

    https://phoenixnap.com/kb/symbolic-link-linux

## Acrescentando -v
Quando vc acrescenta "-v" na busca, vc esta fazendo a busca complemento

    grep -v 'system' /var/log/syslog

Ou seja, dentro do arquivo, syslog, esta sendo feito a busca das linhas que nao contem a palavra 'system'.

Podemos tambem

    grep -v -r "system" *

## Acrescentando -w
Quando vc acrescenta "-w" na busca, vc esta fazendo a busca da palavra inteira. Ou seja, se eu coloco 'system', ela ira realizar uma busca em que apareca apenas a palavra 'system' como a palavra inteira, nao sera considerado, por exemplo, alguma palavra como 'systemd'.

    grep -w 'system' *

## Acrescentando -x
Quando vc acrescenta o "-x" na busca, ele ira encontrar uma linha que tenha somente a tal palavra que esta sendo feito a busca.

    grep -x 'system' *

Ele ira realiza a busca de uma linha que tenha, somente, a palavra "system".

${-x}\subset{-w}$

## Acrescentando -l
Quando vc acrescenta "-l" na busca, ele apenas listara os arquivos em que a palavra que vc busca se encontra

    grep -l 'system' *

## Acrescentando -c
Quando vc acrescenta "-c" na busca, ele apenas mostra a quantidade que se encontra da busca em cada arquivo

    grep -c 'system' *

O ponto e que como sera feita a varredura geral nos arquivos atuais, na busca acima, entao sera exibido ate os arquivos que nao contem a tal palavra buscada e sera contabilizado como 0.

## Acrescentando -o
Quando vc acrescenta "-o" na busca, ela apenas mostra a parte da linha que se combinou ignorando o restante das palavras da mesma linha.

    grep -o 'system' *

## Acrescentando -a
Quando vc acrescenta "-a" na busca, ela realiza a busca apenas nos arquivos binarios

    grep -a 'system' *

## Referencia

    https://phoenixnap.com/kb/grep-command-linux-unix-examples