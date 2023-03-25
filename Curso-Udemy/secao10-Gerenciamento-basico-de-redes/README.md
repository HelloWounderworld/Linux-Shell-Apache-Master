# Seção 10 - Gerenciamento básico de redes:

## Aula 01 - Introdução

## Aula 02 - Como a web funciona
Seguir o link de leitura

    https://es.wikipedia.org/wiki/World_Wide_Web#:~:text=En%20inform%C3%A1tica%2C%20la%20World%20Wide,enlaces%20de%20la%20p%C3%A1gina%20web.
    https://developer.mozilla.org/es/docs/Learn/Common_questions/Web_mechanics/How_does_the_Internet_work

## Aula 03 - O que é DNS?
Seguir o link de leitura

    https://es.wikipedia.org/wiki/Sistema_de_nombres_de_dominio
    https://aws.amazon.com/pt/route53/what-is-dns/

## Aula 04 - O que são portas?
Seguir o link de leitura

    https://www.cloudflare.com/pt-br/learning/network-layer/what-is-a-computer-port/
    https://www.weblink.com.br/blog/tecnologia/conheca-os-principais-protocolos-de-internet/
    https://pt.wikipedia.org/wiki/
    https://definirtec.com/ampliar/29795/qual-a-porta-do-protocolos-http-ftp-e-sshLista_de_portas_dos_protocolos_TCP_e_UDP

## Aula 05 - O que é TCP?
Seguir o link de leitura

    https://es.wikipedia.org/wiki/Protocolo_de_control_de_transmisi%C3%B3n
    https://www.tecmundo.com.br/o-que-e/780-o-que-e-tcp-ip-.htm

## Aula 06 - O que é UDP?
Seguir o link de leitura

    https://es.wikipedia.org/wiki/Protocolo_de_datagramas_de_usuario
    https://gaea.com.br/diferenca-entre-tcp-e-udp/

## Aula 07 - Comando: ping
O comando ping conseguimos saber se estamos conseguindo conectar à internet ou não olhando através de algum link, por exemplo

    ping google.com

Basicamente, se jogarmos o comando acima pelo terminal e ele estiver devolvendo alguma informação do tipo "64 bytes bla bla bla..." significa o seu computador está mandando a solicitação de acesso ao servidor do google e ele está respondendo para ti que está liberado. Ou seja, isso é um indicativo de que a sua máquina está conectado à internet.

O ping, não precisa ser feito necessariamente com um DNS, mas podemos realizar ela diretamente pelo IP.

Para sair do ping basta teclar Ctrl + c.

O ping serve tbm para verifiar se vc tem permissão ou não para acessar um determinado site.

Além disso, podemos usar o ping para verificar se um dado site existe ou se está lento ou não.

## Aula 08 - Comando: netstat
Esse comando netstat (network statistics) serve, basicamente, com o quê o seu computador está ou não conectado ou se comunicando.

Para podermos usar esse comando, primeiramente, vamos precisar instalar ela 

    sudo apt-get install net-tools

Bastaria jogar o comando

    netstat

Ou se quiser ver tudo mesmo

    netstat -a

Ou especificamente, para verificar as conexões tcp

    netstat -at

Para verificar as conexões udp seria

    netstat -au

## Aula 09 - Comando: ifconfig
O comando ifconfig (interface configuration) serve para ou mudar as configurações de redes.

Serve, também, para verificar o ip da sua própria máquina e conseguir conectar, através de uma porta local, com o seu dispositivo mobile.

## Aula 10 - Comando: nslookup
O comando nslookup serve para saber os ips atráves do DNS.

No caso, se jogarmos

    nslookup google.com

por exemplo, ele exibirá o ip dessa dns acima pelo Address.

Mas, lembre-se, que o endereço de ip que é exibido através do dns pelonslookup, ele exibe o endereço do servidor mais próximo que tivemos da nossa localização e que estamos acessando o site.

## Aula 11 - Comando: tcpdump
O comando tcpdump nos permite verificar todas as conexões tcps que estão vindo para a gente

    sudo tcpdump

Em seguida, abra uma outra aba pelo terminal e coloque ping google.com para verificar como é a funcionalidade do tcpdump, isso irá simular quando vc estiver acessando algum navegador ou algum ftp e ele irá exibir isso na sua máquina.

Para sair basta teclar Ctrl + c.

## Aula 12 - Dica: Como ver o ip da sua máquina
Podemos ver usando o ifconfig como foi dito acima.

Mas tem a forma mais precisa que exibe somente o ip mesmo da sua máquina que seria

    hostname -I
