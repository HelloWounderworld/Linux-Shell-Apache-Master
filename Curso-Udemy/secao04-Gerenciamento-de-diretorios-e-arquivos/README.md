# Seção 04 - Gerenciamento de diretórios e arquivos:

## Aula 01 - Introdução

## Aula 02 - Criando diretórios: mkdir
Se vc quiser criar vários diretórios uma dentro da outra bastaria

    mkdir -p (nome do diretório)/(nome do diretório)/(nome do diretório)

## Aula 03 - Removendo arquivos e diretórios: rm

## Aula 04 - Removendo diretórios: rmdir
Para remover os diretórios o comando certo seria

    rmdir (nome do diretório)

O mesmo serve para remoção em cadeia do diretórios

    rmdir -p (nome do diretório)/(nome do diretório)/(nome do diretório)

## Aula 05 - Copiando diretórios e arquivos: cp
Para realizar a cópia de um arquivo, bastaria colocar o seguinte comando

    cp (nome do arquivo existente).(sua extensão) (nome do arquivo que será a cópia).(extensão)

Podemos, tbm, copiar um arquivo para dentro do diretório

    cp (nome do arquivo).(extensão) (diretório onde vc quer que vá a cópia)

Podemos mandar várias cópias de forma simultânea em um diretório concatenando

    cp (nome do arquivo).(extensão) (nome do arquivo).(extensão) (nome do arquivo).(extensão) (diretório onde vc quer que vá a cópia)

Serve para caso vc quiser copiar um diretório e mandar essa cópia de um diretório para dentro de um outro diretório

    cp -r (nome do diretório que vc quer copiar) (diretório onde vc quer mandar a cópia)

Lembrando que o diretório em que vc está direcionando a cópia nem precisaria existir, pois colocando o nome ele será criado automaticamente no processo.

## Aula 06 - Copiando diretórios e arquivos Avançado: cp
Lembrando que só com o cp não conseguimos copiar tudo que está em uma pasta para outra. Para isso, sempre que vc quiser a tal cópia do conteúdo inteiro para o outro precisa-se usar o -r, então ficaria

    cp -r

Uma outra forma de copiarmos tudo, mas se quiser que a cópia do subdiretório vá para outro diretório seria indispensável usar o "-r", seria usando /*, por exemplo

    cp (nome do diretório)/* (nome do diretório onde vc quer enviar a cópia)

    cp -r (nome do diretório)/* (nome do diretório onde vc quer enviar a cópia)

Podemos usar o "*" para copiar todos os arquivos que começam com alguma sigla

    cp (sigla)* (nome do diretório onde vc quer enviar a cópia)

## Aula 07 - Movendo diretórios e arquivos: mv
Se quisermos mandar todos os conteúdo de um diretório para um outro diretório

    mv * (nome do diretório)

## Aula 08 - Dica: saber aonde está com pwd
