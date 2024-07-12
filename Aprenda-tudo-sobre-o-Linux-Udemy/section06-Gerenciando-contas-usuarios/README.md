# Secao 06: Gerenciando contas de usuarios

## Criando contas de usuários
O "useradd" serve para adicionar algum novo usuário e não basta somente esse comando, mas se quiser verificar as opcoes do que ele e possivel bastaria colocar

    useradd

Mas tbm, precisaria colocar mais algum outro comando. Para verificar isso basta colocar useradd no terminal e dar o enter.

    useradd -m '[some name]'
    
cria o usuário com o nome. Mas vc consegue fazer isso mediante de que vc seja o root.

Basicamente, o comando useradd, ele segue as intrucoes padroes que foi configurado no arquivo que fica em /etc/default/useradd. Ao consultar esse arquivo, nela sera exibido o seguinte 

    # Default values for useradd(8)
    #
    # The SHELL variable specifies the default login shell on your
    # system.
    # Similar to DSHELL in adduser. However, we use "sh" here because
    # useradd is a low level utility and should be as general
    # as possible
    SHELL=/bin/sh
    #
    # The default group for users
    # 100=users on Debian systems
    # Same as USERS_GID in adduser
    # This argument is used when the -n flag is specified.
    # The default behavior (when -n and -g are not specified) is to create a
    # primary user group with the same name as the user being added to the
    # system.
    # GROUP=100
    #
    # The default home directory. Same as DHOME for adduser
    # HOME=/home
    #
    # The number of days after a password expires until the account
    # is permanently disabled
    # INACTIVE=-1
    #
    # The default expire date
    # EXPIRE=
    #
    # The SKEL variable specifies the directory containing "skeletal" user
    # files; in other words, files such as a sample .profile that will be
    # copied to the new user's home directory when it is created.
    # SKEL=/etc/skel
    #
    # Defines whether the mail spool should be created while
    # creating the account
    # CREATE_MAIL_SPOOL=yes

Caso vc queira realizar algumas alteracoes na funcionalidade do comando, useradd, podemos apenas descomentar alguns dos parametros acima e atribuir os devidos valores. Porem, precisa ter muito cuidado ao realizar tal manuseio.

Existem varios recursos desse comando, useradd. Iremos explorar uma por uma:

    Usage: useradd [options] LOGIN
        useradd -D
        useradd -D [options]

    Options:
            --badnames                do not check for bad names
        -b, --base-dir BASE_DIR       base directory for the home directory of the
                                        new account
            --btrfs-subvolume-home    use BTRFS subvolume for home directory
        -c, --comment COMMENT         GECOS field of the new account
        -d, --home-dir HOME_DIR       home directory of the new account
        -D, --defaults                print or change default useradd configuration
        -e, --expiredate EXPIRE_DATE  expiration date of the new account
        -f, --inactive INACTIVE       password inactivity period of the new account
        -g, --gid GROUP               name or ID of the primary group of the new
                                        account
        -G, --groups GROUPS           list of supplementary groups of the new
                                        account
        -h, --help                    display this help message and exit
        -k, --skel SKEL_DIR           use this alternative skeleton directory
        -K, --key KEY=VALUE           override /etc/login.defs defaults
        -l, --no-log-init             do not add the user to the lastlog and
                                        faillog databases
        -m, --create-home             create the user's home directory
        -M, --no-create-home          do not create the user's home directory
        -N, --no-user-group           do not create a group with the same name as
                                        the user
        -o, --non-unique              allow to create users with duplicate
                                        (non-unique) UID
        -p, --password PASSWORD       encrypted password of the new account
        -r, --system                  create a system account
        -R, --root CHROOT_DIR         directory to chroot into
        -P, --prefix PREFIX_DIR       prefix directory where are located the /etc/* files
        -s, --shell SHELL             login shell of the new account
        -u, --uid UID                 user ID of the new account
        -U, --user-group              create a group with the same name as the user
        -Z, --selinux-user SEUSER     use a specific SEUSER for the SELinux user mapping
            --extrausers              Use the extra users database

### useradd -D
Vamos explorar o uso do "-D", entao

    useradd -D

ou 

    useradd -D [options]

O acrescento "-D" entra na categoria do "default". No caso, podemos, tambem, utilizar o formato

    useradd --default

ou

    useradd --default [options]

Serve para printar ou mudar a configuracao padrao de um usuario que sera adicionado.

No caso, quando vc digita apenas

    useradd -D

ou

    useradd --default

sera listado algo do seguinte tipo

    GROUP=100                                                                                                                                                                                                HOME=/home
    INACTIVE=-1
    EXPIRE=
    SHELL=/bin/sh
    SKEL=/etc/skel
    CREATE_MAIL_SPOOL=no

Ou seja, ele exibe de forma resumida os parametros padroes configurados dentro do arquivo useradd, que pode ser consultado na path, /etc/default/useradd.

Entao, o que os parametros acima querem me dizer sobre o funcionamento padrao do comando, useradd?

- GROUP=100: O novo usuario e adicionado para um grupo comum com o grupo cujo ID sera 100

- HOME=/home: O novo usuario tem uma conta HOME criado dentro do diretorio "/home".

- INACTIVE=-1: A conta nao pode ser desativado quando a senha expirar.

- EXPIRE=: A nova conta nao pode ser configurado para expirar em uma determinada data.

- SHELL=/bin/sh: A nova conta usa o bash shell como o shell padrao.

- SKEL=/etc/skel: O sistema copia o conteudo do diretorio /etc/skel ao diretorio novo do usuario que foi criado dentro de "/home"

- CREATE_MAIL_SPOOL=no: O sistema cria ou nao um novo arquivo no diretorio mail para o usuario receber a correpondencia.

Ate agora, mostramos apenas a forma como podemos exibir as informacoes configurada de forma padrao.

Nao comentamos nada a respeito de mudar tais configuracoes padroes.

Iremos, agora, abordar isso.

No caso, a formula de uso

    useradd -D [options]

ou

    useradd --default [options]

as opcoes ([options]) que podemos colocar a respeito que sao os que implicam nas mudancas que conseguirmos realizar nas configuracoes padrao. Sao elas:

- -b: default_home, muda a localizacao padrao dos diretorios de usuarios home sao criados.

- -e: expiration_date, muda a data de expiracao em novas contas.

- -f: inactive, muda o numero de dias, depois que uma senha tem se expirado, antes a conte ser desativado.

- -g: group, muda o nome padrao do grupo ou GID usado.

- -s: shell, muda o login padrao shell

Vamos explorar uma por uma as opcoes de comandos acima. Todas elas, soa usadas em conjunto com o "-D".

#### Opcao: -b
A opcao "-b" juntado com o comando "-D" ela serve para mudarmos o diretorio padrao em que o diretorio do usuario sera criado, quando utilizamos o comando "useradd -m username".

No caso, no FHS, na pasta raiz, "/", vamos criar um diretorio "home_teste" utilizando o "mkdir".

Dai, iremos mudar do diretorio "/home" para esse diretorio "/home_teste" como diretorio padrao a ser criado o diretorio de novos usuarios que sao adicionados.

Para isso colocamos o seguinte comando

    useradd -D -b /home_teste

Para verificarmos que, de fato, agora, esta sendo utilizado esse diretorio como diretorio padrao para criar novos diretorios de usuarios novos basta criarmos um novo usuario

    useradd -m teste

Assim, ao darmos

    ll /home_teste

podemos ver que foi criado um diretorio dentro desse "home_teste".

Bom, claro, caso queira voltar para o diretorio "/home" como o diretorio padrao a ser considerado para criar diretorios de novos usuarios basta colocar o comando

    useradd -D -b /home

#### Opcao: -e
A opcao "-e" juntado com o comando "-D" serve para mudarmos as datas de expiracoes de novas contas.

Entao, primeiro, iremos colocar o seguinte

    useradd -D -e 2024-07-13

Ou seja, os novos usuarios que forem criados, com a data acima definida, ira expirar. Estou colocando a data acima, visto que na data em que estou criando esse arquivo texto e 2024-07-12.

Assim, ao criarmos um novo usuario

    useradd -m teste

Esse usuario, ira expirar amanha. Ou seja, bastaria rodar o comando

    grep -E '^[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*:[^:]*$' /etc/shadow

O comando grep ira procurar um usuario dentro do arquivo "shadow" que tenha tal estrutura que indica que ela se expirou.

O resultado desse comando ira exibir todas as entradas de usuarios expirados no sistema, com o seguinte formato

    username:*:17301:0:99999:7:::

- username: O nome do usuário.

- *: O campo da senha, que é geralmente substituído por um asterisco quando a conta está expirada.

- 17301: O número de dias desde a época Unix (1 de janeiro de 1970) em que a senha foi alterada pela última vez.

- 0: O número de dias desde a época Unix em que a conta expira.

- 99999: O número de dias desde a época Unix em que a conta precisa ser alterada.

- 7: O número de dias de aviso antes da expiração da conta.

- ``: Campos em branco.

Ou, caso vc queira verificar se um usuario especifico esta ou nao expirado, bastaria digitar

    sudo grep -E '^username:' /etc/shadow

#### Opcao: -f
A opcao "-f" juntando com o comando "-D" serve para darmos o numero de dias, depois que a senha tem expirado, antes da conta ser desativado.

No caso, ao digitarmos

    useradd -D -f 2

o parametro acima define o numero de dias apos a expiracao da senha antes que a conta seja desativada. No caso, acima o valor foi definido para 2 dias.

Apos executarmos esse comando, sempre que um novo usuario for criado usando o useradd comando, o numero de dias padrao apos a expiracao da senha antes que a conta seja desativada sera definido como 2 dias.

#### Opcao: -g
A opcao "-g" muda o nome do grupo padrao ou GID usado.

No caso, ao digitarmos

    usaradd -D -g developers

este parametro define o grupo padrao para novos usuarios como "developers". Isso significa que, quando um usuario novo foi criado, ele sera adicionado automaticamente ao grupo "developers" como seu grupo primario.

Apos executar esse comando, sempre que um novo usuario for criado usando o useradd comando, o grupo padrao sera definido como "developers".

Claro, tal grupo que vc estiver mencionando no comando acima precisa existir. Entao, sera necessario, primeiro, que crie tal grupo para que o comando acima seja processado de forma bem sucedida.

Para conferirmos que, de fato, apos a criacao de um novo usuario, useradd -m username, depois que realizarmos a configuracao padrao acima, pertence ao novo grupo, bastaria realizar o seguinte

    id username

isso ira exibir o seguinte

    uid=1001(newuser) gid=1002(developers) groups=1002(developers)

No caso, no uid estara indicando o id que vc definiu como o grupo padrao que foi definido quando vc colocou o comando acima.

#### Opcao: -s

### useradd --badnames

### useradd -b ou useradd --base-dir

### useradd --btrfs-subvolume-home

### useradd -c ou useradd --comment

### useradd -d ou useradd --home-dir

### useradd -e ou useradd --expiredate

### useradd -f ou useradd --inactive

### useradd -g ou useradd --gid

### useradd -G ou useradd --groups

### useradd -k ou useradd --skel

### useradd -l ou useradd --no-log-init

### useradd -m ou useradd --create-home

### useradd -M ou useradd --no-create-home

### useradd -N ou useradd --no-user-group

### useradd -o ou useradd --non-unique

### useradd -p ou useradd --password

### useradd -r ou useradd --system

### useradd -R ou useradd --root

### useradd -P ou useradd --prefix

### useradd -s ou useradd --shell

### useradd -u ou useradd --uid

### useradd -U ou useradd --user-group

### useradd -Z ou useradd --selinux-user

### useradd --extrausers

## Alterando usuários
O "usermod" serve para modificar algum usuario ja existente.

    usermod

    Usage: usermod [options] LOGIN

    Options:
        -b, --badnames                allow bad names
        -c, --comment COMMENT         new value of the GECOS field
        -d, --home HOME_DIR           new home directory for the user account
        -e, --expiredate EXPIRE_DATE  set account expiration date to EXPIRE_DATE
        -f, --inactive INACTIVE       set password inactive after expiration
                                        to INACTIVE
        -g, --gid GROUP               force use GROUP as new primary group
        -G, --groups GROUPS           new list of supplementary GROUPS
        -a, --append                  append the user to the supplemental GROUPS
                                        mentioned by the -G option without removing
                                        the user from other groups
        -h, --help                    display this help message and exit
        -l, --login NEW_LOGIN         new value of the login name
        -L, --lock                    lock the user account
        -m, --move-home               move contents of the home directory to the
                                        new location (use only with -d)
        -o, --non-unique              allow using duplicate (non-unique) UID
        -p, --password PASSWORD       use encrypted password for the new password
        -R, --root CHROOT_DIR         directory to chroot into
        -P, --prefix PREFIX_DIR       prefix directory where are located the /etc/* files
        -s, --shell SHELL             new login shell for the user account
        -u, --uid UID                 new UID for the user account
        -U, --unlock                  unlock the user account
        -v, --add-subuids FIRST-LAST  add range of subordinate uids
        -V, --del-subuids FIRST-LAST  remove range of subordinate uids
        -w, --add-subgids FIRST-LAST  add range of subordinate gids
        -W, --del-subgids FIRST-LAST  remove range of subordinate gids
        -Z, --selinux-user SEUSER     new SELinux user mapping for the user account

### usermod -a
Para fornecer permissão sudo (superusuário) para um usuário recém-criado em um sistema Linux, você pode seguir estes passos:

Abra um terminal ou console como usuário root ou com privilégios de superusuário.

Edite o arquivo de configuração do sudo, geralmente localizado em /etc/sudoers. Você pode usar um editor de texto como o nano ou vi para fazer as alterações:

    sudo nano /etc/sudoers

No arquivo /etc/sudoers, localize a seção que contém as linhas de configuração existentes. Geralmente, essa seção começa com a linha # User privilege specification.

Abaixo dessa seção, adicione uma nova linha com o nome do usuário que você deseja adicionar ao sudoers, seguido da palavra-chave ALL=(ALL:ALL) ALL. Isso concederá ao usuário permissão total para usar o comando sudo.

Exemplo:

    # User privilege specification
    root    ALL=(ALL:ALL) ALL
    username    ALL=(ALL:ALL) ALL

Substitua username pelo nome do usuário que você deseja adicionar.

Salve as alterações e saia do editor de texto.

Alternativamente, você também pode usar o comando visudo para editar o arquivo /etc/sudoers. O visudo é uma ferramenta segura que verifica a sintaxe do arquivo antes de salvá-lo, evitando erros de configuração.

    sudo visudo
    
Após fazer as alterações, salve o arquivo e saia.

Agora, o usuário recém-criado terá permissão sudo e poderá executar comandos com privilégios de superusuário usando o prefixo sudo.

Observação importante: Tenha cuidado ao editar o arquivo /etc/sudoers, pois uma configuração incorreta pode tornar o sistema inacessível. É recomendável fazer backup do arquivo antes de fazer quaisquer alterações.

Você pode conceder permissão sudo a um usuário recém-criado no Linux sem a necessidade de editar diretamente o arquivo /etc/sudoers usando um editor de texto. Você pode fazer isso usando o comando usermod.

Aqui estão os passos:

Abra um terminal ou console como usuário root ou com privilégios de superusuário.

Use o comando usermod para adicionar o usuário ao grupo sudo:

    sudo usermod -aG sudo <username>

Substitua <username> pelo nome do usuário que você deseja adicionar ao grupo sudo.

O parâmetro -a (append) garante que o usuário seja adicionado ao grupo sudo sem remover o usuário de outros grupos.
O parâmetro -G (groups) especifica o grupo ao qual o usuário será adicionado.

Verifique se o usuário foi adicionado corretamente ao grupo sudo:

    grep -i <username> /etc/group

Você deve ver o usuário listado no grupo sudo.

Pronto! Agora o usuário recém-criado terá permissão sudo e poderá executar comandos com privilégios de superusuário usando o prefixo sudo.

Essa abordagem é mais conveniente do que editar diretamente o arquivo /etc/sudoers, pois você não precisa se preocupar com a sintaxe do arquivo ou com possíveis erros de configuração.

Observe que, se você quiser remover a permissão sudo de um usuário, basta usar o comando deluser <username> sudo para removê-lo do grupo sudo.

## userdel
O comando "userdel" serve para deletar um usuario

    userdel

    Usage: userdel [options] LOGIN

    Options:
        -f, --force                   force removal of files,
                                        even if not owned by user
        -h, --help                    display this help message and exit
        -r, --remove                  remove home directory and mail spool
        -R, --root CHROOT_DIR         directory to chroot into
        -P, --prefix PREFIX_DIR       prefix directory where are located the /etc/* files
            --extrausers              Use the extra users database
        -Z, --selinux-user            remove any SELinux user mapping for the user

## Locais para verificar os usuarios e suas permissoes

    cat /etc/passwd
    
Serve para verificar se o usuário foi criado, mas claro, o password será exibido de forma encriptada.

Um outro lugar para vericarmos se algum usuario foi logado de forma bem sucedida sendo o root seria em seguinte

    cat /etc/shadow

## Gerenciando as contas de grupo
