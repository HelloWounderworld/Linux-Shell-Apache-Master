# Seção 12 - Projeto - Instalando o LAMP:

## Aula 01 - Introdução

## Aula 02 - Instalando o Apache
Comando para instalar o apache

    sudo apt-get install apache2

No caso, o apache2 é nosso servidor que vai ajudar a configurar uma página web.

Para verificar se o apache foi instalado, basta digitar

    apache2 -v

Outra alternativa que serve de servidor é o nginx.

## Aula 03 - Alterando as configurações do Firewall
O comando 

    sudo ufw app list

Ele listará as aplicações disponíveis em sua máquina.

Visto que na lista temos o "Apache Full", vamos dar permissão à essa aplicação

    sudo ufw allow in "Apache Full"

Quando abrirmos um navegador web e nela digitarmos apenas localhost, irá aparecer a página do apache2.

## Aula 04 - Instalando o MySQL
Vamos colocar o seguinte comando

    sudo apt install mysql-server

Bom, instalado o banco de dados, vamos precisar das permissões para podermos manipular o banco de dados

    sudo mysql_secure_installation

## Aula 05 - Criando um banco de dados
Vamos entrar no banco de dados mysql e criar um banco de dados dentro dela

    sudo mysql -u root

Em seguida, podemos colocar o seguinte

    SHOW DATABASES;

Entrado no mysql, o comando acima mostra todos os banco de dados existentes.

Bom, agora, para os processos de manipulação desse banco de dados, podemos usar a linguagem de consulta que sabemos que é o SQL.

Qualquer coisa, consulta as minhas notas de NodeJS que nela eu usei o banco de dados MySQL para ver todos os processos de manipulação.

O recomendável é que o usuário use o DBeaver que é um app que permite vc realizar as manipulações do banco de dados MySQL com mais facilidade e nitidez.

## Aula 06 - Instalando o PHP
No caso, a linguagem PHP será a nossa linguagem de back-end.

Vamos instalar

    sudo apt install php libapache2-mod-php php-mysql php-cli

O libapache2-mod-php ele serve para que a linguagem PHP estabeleça relação com o banco de dados MySQL.

Vamos, agora, alterar as prioridades de acesso ao arquivo index de html para php

    sudo nano /etc/apache2/mods-enabled/dir.conf

E colocamos o index.php em primeiro.

Agora, vamos reiniciar o apache visto que uma configuração foi alterada

    sudo systemclt reload apache2

ou

    sudo systemctl restart apache2

## Aula 07 - Testando o processamento do PHP no Apache
Vamos ter que testar que se o nosso php está sendo processado pelo nosso servidor. Para isso

    cd /var/www/html

Nela haverá um arquivo index.html que é o que está sendo exibido do apache ao acessarmos o localhost.

Vamos criar um arquivo dentro desse diretório

    sudo nano info.php

Dentro desse arquivo php vc vai ter que colocar o seguinte

    <?php phpinfo(); ?>

Feito isso, no navegador se acessarmos

    localhost/info.php

Deverá aparecer as informações do nosso php nela.

## Aula 08 - Instalando o editor de texto Sublime
Vamos instalar o editor de texto Sublime, em vez de criar tudo no nano ou vim.

No caso, vamos pesquinar no google da vm install sublime 3 on linux

    https://www.sublimetext.com/docs/linux_repositories.html

Daí, indo para a pasta do usuário "cd ~" basta seguir os passos do apt.

Bom, seguido os passos acima, aparecerá um desenho do sublime dentro dos seus apps e vc já pode acessar. Basta procurar pelo icon do sublime, que nem fazemos para procurar o do VSCode.

## Aula 09 - Criando um usuário no MySQL
Vamos precisar criar um usuário no banco de dados MySQL.

Entramos no MySQL

    sudo mysql -u root

Depois colocamos

    GRANT ALL PRIVILEGES ON *.* TO 'leonardo'@'localhost' IDENTIFIED BY 'teste123';

Em seguida, para ver se de fato o usuário foi criado

    SELECT User FROM mysql.user;

## Aula 10 - Concetando ao banco de dados pelo PHP na aplicação
Vamos nos conectar ao banco de dados pelo PHP.

Primeiro, acessamos 

    cd /var/www/html

Nela criamos um diretório

    sudo mkdir app

Em seguida, visto que o diretório app está sobre permissão do usuário root vamos mudar essa permisão para o usuário que está cadastrado, no meu caso é o leonardo

    sudo chown leonardo:leonardo app

Feito isso, vamos ter que criar um arquivo de conexão com o banco de dados MySQL.

No caso, vamos abrir o sublime text e nela abrimos um novo arquivo com nome conn.php e já deixamos salvo esse arquivo no diretório app que criamos. Em seguida, colocamos o seguinte nesse arquivo

    <?php 

        $host = 'localhost';
        $user = 'leonardo';
        $pass = 'teste123';
        $db = 'test';

        $conn = mysqli_connect($host, $user, $pass, $db);

        $sql = 'SELECT * FROM users';
        $result = mysqli_query($conn, $sql);
        $users = mysqli_fetch_all($result, MYSQLI_ASSOC);

        print_r($users);

        mysqli_close($conn);

    ?>

Com isso, para verificarmos se tudo aconteceu bem bastaria acessar pelo navegador

    localhost/app/conn.php

Nela, deverá ser exibido o conteúdo do print_r que colocamos no código acima.

Depois é só comentar o print_r para parar de exibir.

## Aula 11 - Exibindo dados da aplicação no HTML
Agora, só falta criarmos o arquivo index.php que é o arquivo principal. Basicamente, o processo é muito parecido de quando vc vai configurar algum servidor dedicado usando o serviço webhook.

Bom, pelo sublime, vamos criar um novo arquivo com o nome index.php e salvamos esse arquivo no diretório app. Daí, basta digitar html e dar um tab para mostrarmos a estrutura html dentro dessa página. No início desse arquivo vamos colocar o seguinte código php

    <?php
        incluse_once "conn.php";
    ?>

Isso, faz com que a página se conecte com o banco de dados MySQL.

O resto para podermos exibir os conteúdos do banco de dados MySQL é similar ao trabalho que eu realizei ao centerbob quando tive que manipular a página deles com a linguagem html misturado com o php.
