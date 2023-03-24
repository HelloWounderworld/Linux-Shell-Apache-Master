# Seção 05 - Gerenciamento de pacotes/aplicativos:

## Aula 01 - Introdução

## Aula 02 - Atualizando repositórios
Digite

    sudo apt-get update

    sudo apt-get upgrade

poderia colocar sem o "sudo" tbm que funciona, mas fica menos seguro.

## Aula 03 - Instalando pacotes/aplicativos
Digite

    sudo apt-get install (nome do app ou pacote que vc queira instalar)

Mas antes mesmo de vc instalar algo verifique se o mesmo já não está instalado. Pois isso evita que vc faça instalações desnecessárias.

Para facilitar isso, é recomendável que instale o tree. Claro, digite primeiro "tree" no terminal se ele está ou não instalado e visto que não foi instalado, então digite

    sudo apt-get install tree

## Aula 04 - Deletando um pacote/aplicativo
Digite

    sudo apt-get purge (nome do app ou pacote)

Se vc instalou o tree na aula anterior, tenta desinstalar ela

    sudo apt-get purge tree

## Aula 05 - Atualizando o Linux
O comando que vou passar aqui agora é bem delicado, pois precisa ter muito cuidado ao utilizar ele, pois ele tem um grande potencial de zuar o seu ambiente se vc utilizar ele de forma indevida

    sudo apt-get dist-upgrade

No caso, o comando acima geralmente é utilizado mais para caso em que o seu linux muda de versão.

O motivo do comando acima ser muito delicado seria devido ao fato de que a atualização de uma mudança da versão para outra é feito de forma bem invasiva com o comando acima. No sentido de que, além de atualizar para nova versão em sí, ou seja, atualizando os pacotes para novas versões, ele tbm remove os pacotes antigos. No meio desse processo, pode acontecer de vc remover pacotes que não eram para serem removidas.

Na medida do possível, sempre use

    sudo apt-get upgrade

E usar o comando com o dist, faça somente nos momentos em que vc tiver certeza de que isso é necessário e que não ocorrerá nenhum problema.

## Aula 06 - Limpando pacotes/aplicativos desnecessários
Formas para limpar as sujeiras

    sudo apt-get autoremove

Serve mais para realizar a limpeza na máquina e que é recomedável que seja feito com uma certa frequência junto com as atualizações que ocorrem.

## Aula 07 - Buscando pacotes/aplicativos
Para buscar algum app que vc esteja procurando dentro da máquina

    apt-cache search (nome do pacote ou app, ou as suas siglas iniciais)

## Aula 08 - Dica: Utilizando apenas apt

## Aula 09 - Dica: Salvando o estado da máquina
