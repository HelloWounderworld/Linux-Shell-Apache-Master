# Seção 11 - Compactação e descompactação de arquivos e diretórios:

## Aula 01 - Introdução

## Aula 02 - Compactando arquivos com tar
Para compactar os arquivos com o tar basta realizar o seguinte

    tar -czvf compactado.tar.gz (nome de algum diretório)

Feito isso, o diretório que vc compactou será exibido pelo nome "compactado.tar.gz".

Seguir o link de leitura

    https://www.baeldung.com/linux/tar-archive-without-directory-structure#:~:text=The%20Linux%20tar%20command%20is,directory%20structure%20of%20archived%20files.
    https://www.geeksforgeeks.org/tar-command-linux-examples/

## Aula 03 - Compactando múltiplos arquivos em um só
Para compactar múltiplos arquivos em um só seria o seguinte

    tar -czvf compactado2.tar.gz (nome do arquivo).(extensão) (nome do arquivo).(extensão) (nome do arquivo).(extensão) (nome de diretório) (nome de diretório) (nome de diretório)

No caso, vc pode colocar arquivos e nomes de diretórios o quanto vc quiser para compactar. Feito o comando acima, será exibido um arquivo compactado com o nome "compactado2.tar.gz".

## Aula 04 - Descompactando arquivos
O comando para extrair o arquivo compactado é o seguinte

    tar -xzvf (nome do arquivo compactado com a sua extensão)

Se vc quiser realizar a extração em um outro diretório bastaria colocar o seguinte

    tar -xzvf (nome do arquivo compactado com a sua extensão) -C (nome do diretório)/

## Aula 05 - Compactação em zip
O comando para realizar a compactação zip

    zip -r (nome que vc quer salvar).zip (nome do diretório que vc quer compactar)

No caso, com o comando acima vc irá conseguir compactar um diretório com o nome que vc quer salvar com a extensão .zip.

## Aula 06 - Descompactando arquivos em zip
Para descompactar o arquivo zip é o seguinte

    unzip (nome do arquivo compactado).zip -d (o diretório destino que vc quer extrair)/

## Aula 07 - Dica: veja o que tem dentro dos arquivos compactados
Se vc quiser ver qual é o conteúdo dentro do arquivo compactado bastaria jogar o seguinte

    tar -tvf (nome do arquivo compactado com a sua extensão)
