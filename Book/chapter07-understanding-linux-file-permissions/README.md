# Understanding Linux File Permissions

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
A opcao "-s" muda o padrao de login shell ([1]).

No caso, ao digitarmos

    useradd -D -s /bin/zsh

define o shell padrao para novos usuarios como /bin/zsh. Isso significa que, quando um novo usuario for criado, seu shell padrao sera o zsh.

[1]: https://github.com/HelloWounderworld/Linux-Shell-Apache-Master/tree/main/Aprenda-tudo-sobre-o-Linux-Udemy/section06-Gerenciando-contas-usuarios/default-login-shell

### useradd --badnames
O comando useradd --badnames permite a criação de usuários com nomes que normalmente seriam considerados inválidos ou "ruins" pelo sistema. Isso pode incluir nomes com caracteres especiais, espaços, ou outros formatos que não seguem as convenções padrão de nomes de usuários.

Bom, a sintaxe do comando, visto que vc esta como root, seria

    useradd --badnames <nome_do_usuario>

Vamos criar um usuário com um nome que normalmente seria rejeitado, como "user!@#".

    useradd --badnames "user!@#"

Para verificar se o usuario foi criado com sucesso, voce pode listar os usuarios no sistema

    cat /etc/passwd | grep "user!@#"

Se o usuário foi criado corretamente, você verá uma linha correspondente no arquivo /etc/passwd.

Obs: Usar nomes de usuários com caracteres especiais pode causar problemas com scripts e programas que não esperam esses tipos de nomes. Portanto, use essa opção com cautela e apenas quando necessário.

### useradd -b ou useradd --base-dir
O comando "useradd -b" ou "useradd --base-dir" é usado para especificar o diretório base onde os diretórios home dos novos usuários serão criados. Este comando é útil quando você deseja que os diretórios home dos usuários sejam criados em um local diferente do padrão /home.

A sintaxe seria, visto que vc esta como root

    useradd -b <base_dir> <username>

ou

    useradd --base-dir <base_dir> <username>

- <base_dir>: O diretório base onde o diretório home do novo usuário será criado.

- <username>: O nome do novo usuário.

Vamos criar um novo usuário chamado testeuser e definir o diretório base para /home_teste.

1. Primeiro, crie o diretório /home_teste, estando no diretorio raiz, "/"

        mkdir /home_teste

2. Em seguida, use o comando useradd com a opção -b para criar o usuário testeuser com o diretório home em /home_teste:

        useradd -b /home_teste -m testeuser

3. Verifique se o diretório home foi criado corretamente:

        ls /home_teste

    Você deve ver um diretório chamado testeuser dentro de /home_teste.

Resumo do comando:

    mkdir /home_teste
    useradd -b /home_teste -m testeuser
    ls /home_teste

Este exemplo mostra como criar um novo usuário com um diretório home em um local diferente do padrão.

### useradd --btrfs-subvolume-home
O comando useradd --btrfs-subvolume-home é usado para criar o diretório home de um novo usuário como um subvolume Btrfs. Btrfs (B-tree file system) ([2]) é um sistema de arquivos moderno que oferece várias funcionalidades avançadas, como snapshots, subvolumes, e verificação de integridade.

A sua sintaxe seria

    useradd --btrfs-subvolume-home <username>

Quando você usa a opção --btrfs-subvolume-home, o diretório home do novo usuário será criado como um subvolume Btrfs, o que pode ser útil para gerenciamento de snapshots e outras funcionalidades específicas do Btrfs.

Vamos criar um novo usuário chamado btrfsuser e definir seu diretório home como um subvolume Btrfs.

1. Certifique-se de que o sistema de arquivos onde o diretório home será criado é Btrfs. Você pode verificar isso com o comando df -T:

        df -T /home

2. Crie o usuário btrfsuser com o diretório home como um subvolume Btrfs:

        useradd --btrfs-subvolume-home -m btrfsuser

3. Verifique se o diretório home foi criado corretamente e se é um subvolume Btrfs:

        btrfs subvolume list /home

    Você deve ver uma entrada para o subvolume correspondente ao diretório home do usuário btrfsuser.

Resumo do comando:

    df -T /home
    useradd --btrfs-subvolume-home -m btrfsuser
    btrfs subvolume list /home

Este exemplo mostra como criar um novo usuário com um diretório home como um subvolume Btrfs, aproveitando as funcionalidades avançadas do sistema de arquivos Btrfs.

[2]:https://github.com/HelloWounderworld/Linux-Shell-Apache-Master/tree/main/Aprenda-tudo-sobre-o-Linux-Udemy/section06-Gerenciando-contas-usuarios/btrfs

### useradd -c ou useradd --comment
O comando "useradd -c" ou "useradd --comment" é usado para adicionar um comentário ou descrição ao campo GECOS (General Electric Comprehensive Operating System) de uma nova conta de usuário. Esse campo geralmente contém informações como o nome completo do usuário, número de telefone, etc.

Sintaxe, considerando que vc esteja como root

    useradd -c "comentário" username

ou

    useradd --comment "comentário" username

#### Exemplo de uso
Vamos criar um usuário chamado jdoe com um comentário que descreve o nome completo do usuário.

    useradd -c "John Doe" jdoe

#### Verificando o Comentário
Para verificar se o comentário foi adicionado corretamente, você pode usar o comando getent para listar as informações do usuário.

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001:John Doe:/home/jdoe:/bin/bash

Aqui, John Doe é o comentário que foi adicionado ao campo GECOS.

Explicação dos Campos:

A linha de saída do comando getent passwd jdoe contém os seguintes campos, separados por dois-pontos (:):

1. Nome de usuário: jdoe

2. Senha: x (indica que a senha está armazenada no arquivo /etc/shadow)

3. UID: 1001 (User ID)

4. GID: 1001 (Group ID)

5. GECOS: John Doe (Comentário)

6. Diretório home: /home/jdoe

7. Shell de login: /bin/bash

O comando useradd -c ou useradd --comment é útil para adicionar informações descritivas sobre o usuário, facilitando a identificação e o gerenciamento de contas no sistema.

### useradd -d ou useradd --home-dir
O comando "useradd -d" ou "useradd --home-dir" é usado para especificar um diretório home diferente do padrão ao criar uma nova conta de usuário. Por padrão, o diretório home de um novo usuário é criado em /home/username, mas com essa opção, você pode definir um caminho diferente.

Sintaxe, considerando que vc seja o root

    useradd -d /caminho/para/diretorio username

ou

    useradd --home-dir /caminho/para/diretorio username

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe e definir seu diretório home para /custom/home/jdoe.

1. Crie o diretório customizado (se ainda não existir):

        mkdir -p /custom/home/jdoe

2. Crie o usuário com o diretório home especificado:

        useradd -d /custom/home/jdoe -m jdoe

    A opção -m ou --create-home é usada para criar o diretório home se ele não existir.

#### Verificando o Diretório Home
Para verificar se o diretório home foi configurado corretamente, você pode usar o comando getent:

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001::/custom/home/jdoe:/bin/bash

Aqui, /custom/home/jdoe é o diretório home que foi especificado.

Explicação dos Campos:

1. Nome de usuário: jdoe

2. Senha: x (indica que a senha está armazenada no arquivo /etc/shadow)

3. UID: 1001 (User ID)

4. GID: 1001 (Group ID)

5. GECOS: (Comentário, vazio neste exemplo)

6. Diretório home: /custom/home/jdoe

7. Shell de login: /bin/bash

O comando useradd -d ou useradd --home-dir é útil quando você precisa criar um usuário com um diretório home em um local diferente do padrão. Isso pode ser necessário por razões de organização, segurança ou requisitos específicos de aplicação.

### useradd -e ou useradd --expiredate
O comando "useradd -e" ou "useradd --expiredate" é usado para definir uma data de expiração para uma nova conta de usuário. Após essa data, o usuário não poderá mais fazer login no sistema. Isso é útil em situações onde você precisa criar contas temporárias ou limitar o acesso de um usuário a um período específico.

Sintaxe, considerando que vc seja o root

    useradd -e YYYY-MM-DD username

ou

    useradd --expiredate YYYY-MM-DD username

- YYYY-MM-DD: A data de expiração no formato ano-mês-dia.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe cuja conta expira em 31 de dezembro de 2024.

    sudo useradd -e 2024-12-31 jdoe

#### Verificando a Data de Expiração
Para verificar se a data de expiração foi configurada corretamente, você pode usar o comando chage:

    chage -l jdoe

A saída incluirá uma linha como:

    Account expires    : Dec 31, 2024

##### Explicação dos Campos:

A linha de saída do comando chage -l jdoe contém várias informações sobre a conta do usuário, incluindo a data de expiração.

##### Alterando a Data de Expiração de um Usuário Existente
Se você precisar alterar a data de expiração de um usuário existente, pode usar o comando usermod:

    usermod -e 2025-01-31 jdoe

##### Verificando a Data de Expiração no Arquivo /etc/shadow
A data de expiração também é armazenada no arquivo /etc/shadow. Você pode verificar isso com o comando grep:

    grep '^jdoe:' /etc/shadow

A saída será algo como:

    jdoe:$6$randomhash$...:19000:0:99999:7::19358:

O último campo (19358 neste exemplo) representa a data de expiração em dias desde 1 de janeiro de 1970 (época Unix). Você pode converter esse número para uma data legível usando um comando como date:

    date -d '1970-01-01 +19358 days'

O comando useradd -e ou useradd --expiredate é útil para criar contas de usuário com uma data de expiração específica, permitindo um controle mais granular sobre o acesso ao sistema. Isso é especialmente útil em ambientes onde o acesso temporário é necessário.

### useradd -f ou useradd --inactive
O comando useradd -f ou useradd --inactive é usado para definir o número de dias após a expiração da senha de um usuário antes que a conta seja desativada. Isso é útil para garantir que os usuários atualizem suas senhas em tempo hábil e para desativar contas que não foram atualizadas.

Sintaxe, considerando que vc seja o root

    useradd -f INACTIVE_DAYS username

ou

    useradd --inactive INACTIVE_DAYS username

- INACTIVE_DAYS: O número de dias após a expiração da senha antes que a conta seja desativada. Um valor de 0 desativa a conta imediatamente após a expiração da senha. Um valor de -1 desativa essa funcionalidade.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe e definir que sua conta será desativada 7 dias após a expiração da senha.

    sudo useradd -f 7 jdoe

Agora, como experimento, vamos determinar a data de expiracao dessa senha

    sudo chage -W 8 jdoe

Assim, sera determinado a data de expiracao.

Definimos a senha para o jdoe

    sudo passwd jdoe

Colocamos uma senha simples: 12345

#### Verificando a Configuração de Inatividade
Para verificar se a configuração de inatividade foi aplicada corretamente, você pode usar o comando chage:

    sudo chage -l jdoe

A saída incluirá uma linha como:

    Password inactive : 7 days after expiration

#### Explicação dos Campos
A linha de saída do comando chage -l jdoe contém várias informações sobre a conta do usuário, incluindo o período de inatividade após a expiração da senha.

##### Alterando o Período de Inatividade de um Usuário Existente
Se você precisar alterar o período de inatividade de um usuário existente, pode usar o comando usermod:

    sudo usermod -f 10 jdoe

#### Verificando a Configuração de Inatividade no Arquivo /etc/shadow
A configuração de inatividade também é armazenada no arquivo /etc/shadow. Você pode verificar isso com o comando grep:

    sudo grep '^jdoe:' /etc/shadow

A saída será algo como:

    jdoe:$6$randomhash$...:19000:0:99999:7:10::

O penúltimo campo (10 neste exemplo) representa o número de dias de inatividade após a expiração da senha.

O comando useradd -f ou useradd --inactive é útil para garantir que as contas de usuário sejam desativadas após um período de inatividade, incentivando os usuários a atualizar suas senhas regularmente. Isso é especialmente importante em ambientes onde a segurança é uma preocupação crítica.

### useradd -g ou useradd --gid
O comando "useradd -g" ou "useradd --gid" é usado para especificar o grupo primário de um novo usuário durante a criação da conta. O grupo primário é o grupo ao qual o usuário pertence por padrão e é usado para definir permissões de arquivos e diretórios.

Sintaxe, considerando que vc seja root

    useradd -g groupname username

ou

    useradd --gid groupname username

- groupname: O nome ou ID do grupo primário que você deseja atribuir ao usuário.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar um grupo chamado developers e, em seguida, criar um usuário chamado jdoe que pertence a esse grupo como seu grupo primário.

##### Passo 1: Criar o Grupo
Primeiro, crie o grupo developers (se ainda não existir):

    sudo groupadd developers

##### Passo 2: Criar o Usuário com o Grupo Primário Especificado
Agora, crie o usuário jdoe e atribua o grupo developers como seu grupo primário:

    sudo useradd -g developers jdoe

#### Verificando a Configuração
Para verificar se o usuário jdoe foi criado corretamente e pertence ao grupo developers, você pode usar o comando id:

    id jdoe

A saída será algo como:

    uid=1001(jdoe) gid=1002(developers) groups=1002(developers)

Aqui, gid=1002(developers) indica que o grupo primário do usuário jdoe é developers.

##### Explicação dos Campos
A linha de saída do comando id jdoe contém os seguintes campos:

- uid=1001(jdoe): O ID do usuário e o nome do usuário.

- gid=1002(developers): O ID do grupo primário e o nome do grupo primário.

- groups=1002(developers): A lista de grupos aos quais o usuário pertence (neste caso, apenas o grupo primário).

O comando useradd -g ou useradd --gid é útil para especificar o grupo primário de um novo usuário durante a criação da conta. Isso é importante para definir as permissões de arquivos e diretórios de forma adequada.

### useradd -G ou useradd --groups
O comando "useradd -G" ou "useradd --groups" é usado para adicionar um novo usuário a um ou mais grupos suplementares durante a criação da conta. Grupos suplementares são grupos adicionais aos quais o usuário pertence, além do grupo primário. Isso é útil para conceder permissões adicionais ao usuário em diferentes contextos.

Sintaxe, considerando que vc seja um root

    useradd -G group1,group2,... username

ou

    useradd --groups group1,group2,... username

- group1,group2,...: Uma lista de grupos suplementares separados por vírgulas.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar dois grupos chamados developers e admins, e em seguida, criar um usuário chamado jdoe que pertence ao grupo primário developers e aos grupos suplementares admins e users.

##### Passo 1: Criar os Grupos
Primeiro, crie os grupos developers, admins e users (se ainda não existirem):

    groupadd developers
    groupadd admins
    groupadd users

##### Passo 2: Criar o Usuário com Grupos Suplementares Especificados
Agora, crie o usuário jdoe e atribua o grupo primário developers e os grupos suplementares admins e users:

    sudo useradd -g developers -G admins,users jdoe

#### Verificando a Configuração
Para verificar se o usuário jdoe foi criado corretamente e pertence aos grupos especificados, você pode usar o comando id:

    id jdoe

A saída será algo como:

    uid=1001(jdoe) gid=1002(developers) groups=1002(developers),1003(admins),1004(users)

Aqui, gid=1002(developers) indica que o grupo primário do usuário jdoe é developers, e groups=1002(developers),1003(admins),1004(users) indica que o usuário também pertence aos grupos admins e users.

##### Explicação dos Campos
A linha de saída do comando id jdoe contém os seguintes campos:

- uid=1001(jdoe): O ID do usuário e o nome do usuário.

- gid=1002(developers): O ID do grupo primário e o nome do grupo primário.

- groups=1002(developers),1003(admins),1004(users): A lista de grupos aos quais o usuário pertence, incluindo o grupo primário e os grupos suplementares.

O comando useradd -G ou useradd --groups é útil para adicionar um novo usuário a múltiplos grupos durante a criação da conta. Isso permite conceder permissões adicionais ao usuário em diferentes contextos, facilitando a gestão de acesso e permissões no sistema.

### useradd -k ou useradd --skel
O comando "useradd -k" ou "useradd --skel" é usado para especificar um diretório alternativo de esqueleto (skeleton directory) ao criar uma nova conta de usuário. O diretório de esqueleto contém arquivos e diretórios padrão que são copiados para o diretório home do novo usuário. Por padrão, o diretório de esqueleto é /etc/skel.

Sintaxe, considerando que vc seja o root

    useradd -k /caminho/para/skel_dir username

ou

    useradd --skel /caminho/para/skel_dir username

- /caminho/para/skel_dir: O caminho para o diretório de esqueleto alternativo.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar um diretório de esqueleto alternativo chamado /custom/skel e, em seguida, criar um usuário chamado jdoe que usará esse diretório de esqueleto.

##### Passo 1: Criar o Diretório de Esqueleto Alternativo
Primeiro, crie o diretório de esqueleto alternativo e adicione alguns arquivos padrão:

    sudo mkdir -p /custom/skel
    echo "Bem-vindo ao seu novo diretório home!" | sudo tee /custom/skel/welcome.txt

##### Passo 2: Criar o Usuário com o Diretório de Esqueleto Especificado
Agora, crie o usuário jdoe e especifique o diretório de esqueleto alternativo:

    sudo useradd -k /custom/skel -m jdoe

- A opção -m ou --create-home é usada para criar o diretório home do usuário.

#### Verificando a Configuração
Para verificar se o diretório home do usuário jdoe foi criado corretamente com os arquivos do diretório de esqueleto alternativo, você pode listar o conteúdo do diretório home do usuário:

    ls -la /home/jdoe

Você deve ver o arquivo welcome.txt copiado do diretório de esqueleto alternativo:

    total 12
    drwxr-xr-x 2 jdoe jdoe 4096 Jul 12 12:34 .
    drwxr-xr-x 3 root root 4096 Jul 12 12:34 ..
    -rw-r--r-- 1 jdoe jdoe   32 Jul 12 12:34 welcome.txt

##### Explicação dos Campos
A linha de saída do comando ls -la /home/jdoe contém os seguintes campos:

- drwxr-xr-x: As permissões do diretório.

- 2 jdoe jdoe: O número de links e o proprietário e grupo do diretório.

- 4096 Jul 12 12:34: O tamanho do diretório e a data e hora de criação.

- .: O diretório atual.

- ..: O diretório pai.

- -rw-r--r--: As permissões do arquivo welcome.txt.

- 1 jdoe jdoe: O número de links e o proprietário e grupo do arquivo.

- 32 Jul 12 12:34: O tamanho do arquivo e a data e hora de criação.

- welcome.txt: O nome do arquivo.

O comando useradd -k ou useradd --skel é útil para especificar um diretório de esqueleto alternativo ao criar uma nova conta de usuário. Isso permite personalizar os arquivos e diretórios padrão que são copiados para o diretório home do novo usuário.

### useradd -l ou useradd --no-log-init
O comando "useradd -l" ou "useradd --no-log-init" é usado para criar um novo usuário sem adicionar entradas nos arquivos de log do sistema, como lastlog e faillog. Esses arquivos são usados para registrar informações sobre os últimos logins e tentativas de login falhadas dos usuários. Em algumas situações, pode ser desejável criar um usuário sem registrar essas informações, por exemplo, para contas de serviço ou scripts automatizados.

Sintaxe, considerando que vc seja root

    useradd -l username

ou

    useradd --no-log-init username

#### Exemplo de Uso
Para verificar se o usuário foi criado corretamente, você pode usar o comando getent passwd:

    getent passwd serviceuser

A saída será algo como:

    serviceuser:x:1001:1001::/home/serviceuser:/bin/bash

#### Verificando os Arquivos de Log
Para confirmar que o usuário não foi adicionado aos arquivos de log lastlog e faillog, você pode usar os seguintes comandos:

##### Verificando lastlog

    sudo lastlog -u serviceuser

Se o usuário não tiver uma entrada no lastlog, a saída será algo como:

    Username         Port     From             Latest
    serviceuser                               **Never logged in**

##### Verificando faillog

    sudo faillog -u serviceuser

Se o usuário não tiver uma entrada no faillog, a saída será algo como:

    Username   Failures Maximum Latest                   On
    serviceuser     0        0    **Never logged in**

##### Explicação dos Campos
A linha de saída dos comandos lastlog e faillog contém informações sobre os últimos logins e tentativas de login falhadas dos usuários. No caso do usuário serviceuser, as entradas indicam que ele nunca fez login, o que é esperado, pois não há registros nos arquivos de log.

O comando useradd -l ou useradd --no-log-init é útil para criar usuários sem adicionar entradas nos arquivos de log do sistema, como lastlog e faillog. Isso pode ser desejável para contas de serviço ou scripts automatizados onde o registro de logins não é necessário.

### useradd -m ou useradd --create-home
O comando "useradd -m" ou "useradd --create-home" é usado para criar um novo usuário e, ao mesmo tempo, criar automaticamente o diretório home para esse usuário. O diretório home é o local onde os arquivos pessoais do usuário serão armazenados, e ele é criado com permissões apropriadas e arquivos padrão copiados do diretório de esqueleto (geralmente /etc/skel).

Sintaxe, considerando que vc seja root

    useradd -m username

ou

    useradd --create-home username

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe e criar automaticamente o diretório home para ele.

    sudo useradd -m jdoe

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se o diretório home foi criado, você pode usar os seguintes comandos:

##### Verificando o Usuário

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/bash

Aqui, /home/jdoe é o diretório home que foi criado.

#### Verificando o Diretório Home
Para verificar se o diretório home foi criado e contém os arquivos padrão, você pode listar o conteúdo do diretório home do usuário:

    ls -la /home/jdoe

A saída será algo como:

    total 12
    drwxr-xr-x 2 jdoe jdoe 4096 Jul 12 12:34 .
    drwxr-xr-x 3 root root 4096 Jul 12 12:34 ..
    -rw-r--r-- 1 jdoe jdoe   32 Jul 12 12:34 .bashrc
    -rw-r--r-- 1 jdoe jdoe   32 Jul 12 12:34 .profile
    -rw-r--r-- 1 jdoe jdoe   32 Jul 12 12:34 .bash_logout

##### Explicação dos Campos
A linha de saída do comando ls -la /home/jdoe contém os seguintes campos:

- drwxr-xr-x: As permissões do diretório

- 2 jdoe jdoe: O número de links e o proprietário e grupo do diretório.

- 4096 Jul 12 12:34: O tamanho do diretório e a data e hora de criação.

- .: O diretório atual.

- ..: O diretório pai.

- -rw-r--r--: As permissões dos arquivos padrão.

- 1 jdoe jdoe: O número de links e o proprietário e grupo dos arquivos.

- 32 Jul 12 12:34: O tamanho dos arquivos e a data e hora de criação.

- .bashrc, .profile, .bash_logout: Os nomes dos arquivos padrão copiados do diretório de esqueleto.

O comando useradd -m ou useradd --create-home é útil para criar um novo usuário e garantir que um diretório home seja criado automaticamente com os arquivos padrão. Isso facilita a configuração inicial do ambiente do usuário e garante que ele tenha um local adequado para armazenar seus arquivos pessoais.

### useradd -M ou useradd --no-create-home
O comando "useradd -M" ou "useradd --no-create-home" é usado para criar um novo usuário sem criar automaticamente um diretório home para ele. Isso pode ser útil em situações onde o usuário não precisa de um diretório home, como contas de serviço ou usuários que não armazenarão arquivos pessoais no sistema.

Sintaxe, considerando que vc seja root

    useradd -M username

ou

    useradd --no-create-home username

#### Exemplo de Uso
Vamos criar um usuário chamado serviceuser sem criar um diretório home para ele.

    sudo useradd -M serviceuser

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se o diretório home não foi criado, você pode usar os seguintes comandos:

##### Verificando o Usuário

    getent passwd serviceuser

A saída será algo como:

    serviceuser:x:1001:1001::/home/serviceuser:/bin/bash

Aqui, /home/serviceuser é o diretório home padrão que seria usado, mas não foi criado.

#### Verificando a Ausência do Diretório Home
Para verificar se o diretório home não foi criado, você pode listar o conteúdo do diretório /home:

    ls -la /home

Você não deve ver um diretório chamado serviceuser na saída.

##### Explicação dos Campos
A linha de saída do comando getent passwd serviceuser contém os seguintes campos:

- serviceuser: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1001: O UID (User ID) do usuário.

- 1001: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/serviceuser: O diretório home padrão que seria usado, mas não foi criado.

- /bin/bash: O shell de login do usuário.

O comando useradd -M ou useradd --no-create-home é útil para criar usuários que não precisam de um diretório home, como contas de serviço ou usuários que não armazenarão arquivos pessoais no sistema. Isso pode ajudar a manter o sistema mais organizado e seguro, evitando a criação de diretórios home desnecessários.

### useradd -N ou useradd --no-user-group
O comando "useradd -N" ou "useradd --no-user-group" é usado para criar um novo usuário sem criar um grupo com o mesmo nome do usuário. Por padrão, ao criar um novo usuário, o sistema também cria um grupo com o mesmo nome do usuário e o adiciona a esse grupo como seu grupo primário. Com a opção -N ou --no-user-group, você pode evitar a criação desse grupo e, em vez disso, adicionar o usuário a um grupo existente.

Sintaxe, considerando que vc seja root

    useradd -N username

ou

    useradd --no-user-group username

#### Exemplo de Uso
Vamos criar um grupo chamado sharedgroup e, em seguida, criar um usuário chamado jdoe que será adicionado a esse grupo como seu grupo primário, sem criar um grupo com o nome jdoe.

##### Passo 1: Criar o Grupo
Primeiro, crie o grupo sharedgroup (se ainda não existir):

    sudo groupadd sharedgroup

##### Passo 2: Criar o Usuário sem Criar um Grupo com o Mesmo Nome
Agora, crie o usuário jdoe e adicione-o ao grupo sharedgroup como seu grupo primário:

    sudo useradd -N -g sharedgroup jdoe

OBS: caso vc utilize somente -N sem adicionar algum grupo especifico, ao darmos

    id jdoe

iremos ver que ele foi adicionado ao grupo user, que tem gid, por padrao, 100.

#### Verificando a Configuração
Para verificar se o usuário jdoe foi criado corretamente e pertence ao grupo sharedgroup, você pode usar o comando id:

    id jdoe

A saída será algo como:

    uid=1001(jdoe) gid=1002(sharedgroup) groups=1002(sharedgroup)

Aqui, gid=1002(sharedgroup) indica que o grupo primário do usuário jdoe é sharedgroup.

##### Explicação dos Campos
A linha de saída do comando id jdoe contém os seguintes campos:

- uid=1001(jdoe): O ID do usuário e o nome do usuário.

- gid=1002(sharedgroup): O ID do grupo primário e o nome do grupo primário.

- groups=1002(sharedgroup): A lista de grupos aos quais o usuário pertence (neste caso, apenas o grupo primário).

O comando useradd -N ou useradd --no-user-group é útil para criar um novo usuário sem criar um grupo com o mesmo nome do usuário. Isso é especialmente útil em ambientes onde você deseja que vários usuários compartilhem o mesmo grupo primário ou quando você deseja evitar a criação de muitos grupos individuais.

### useradd -o ou useradd --non-unique
O comando "useradd -o" ou "useradd --non-unique" é usado para permitir a criação de um novo usuário com um UID (User ID) duplicado, ou seja, um UID que já está em uso por outro usuário no sistema. Por padrão, cada usuário deve ter um UID único, mas em algumas situações específicas, pode ser necessário que dois ou mais usuários compartilhem o mesmo UID.

Sintaxe, considerando que vc seja root

    useradd -o -u UID username

ou

    useradd --non-unique --uid UID username

- -o ou --non-unique: Permite a criação de um usuário com um UID duplicado.

- -u UID ou --uid UID: Especifica o UID que será atribuído ao novo usuário.

- username: O nome do usuário que está sendo criado.

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe2 com o mesmo UID que o usuário jdoe.

##### Passo 1: Verificar o UID do Usuário Existente
Primeiro, verifique o UID do usuário jdoe:

    id jdoe

A saída será algo como:

    uid=1001(jdoe) gid=1001(jdoe) groups=1001(jdoe)

Aqui, o UID do usuário jdoe é 1001.

##### Passo 2: Criar o Novo Usuário com o UID Duplicado
Agora, crie o usuário jdoe2 com o mesmo UID 1001:

    sudo useradd -o -u 1001 jdoe2

#### Verificando a Configuração
Para verificar se o usuário jdoe2 foi criado corretamente com o UID duplicado, você pode usar o comando id:

    id jdoe2

A saída será algo como:

    uid=1001(jdoe2) gid=1002(jdoe2) groups=1002(jdoe2)

Aqui, uid=1001(jdoe2) indica que o usuário jdoe2 foi criado com o mesmo UID que jdoe.

##### Explicação dos Campos
A linha de saída do comando id jdoe2 contém os seguintes campos:

- uid=1001(jdoe2): O ID do usuário e o nome do usuário.

- gid=1002(jdoe2): O ID do grupo primário e o nome do grupo primário.

- groups=1002(jdoe2): A lista de grupos aos quais o usuário pertence (neste caso, apenas o grupo primário).

#### Considerações de Segurança
Usar UIDs duplicados pode ter implicações de segurança e gerenciamento, pois os dois usuários compartilharão permissões de arquivos e diretórios. Isso deve ser feito com cuidado e apenas em situações específicas onde é realmente necessário.

O comando useradd -o ou useradd --non-unique é útil para criar um novo usuário com um UID duplicado, permitindo que dois ou mais usuários compartilhem o mesmo UID. Isso pode ser necessário em situações específicas, mas deve ser usado com cautela devido às implicações de segurança e gerenciamento.

##### OBS
Se vc criar um usuario com o mesmo uid do usuario admin que vc esta logado, no momento, vc nao ira conseguir realizar alteracoes ou remocao sobre esse novo usuario, pois sera mostrado uma mensagem sobre processo em execucao. Isso e indicativo de que esse usuario novo que vc acabou de criar tem as mesmas permissoes de acesso do admin. Se vc quiser realizar alguma alteracao sobre esse usuario vc tera que deslogar do admin e logar numa outra conta de usuario para realizar tais alteracoes desejadas.

### useradd -p ou useradd --password
O comando useradd -p ou useradd --password é usado para definir a senha de um novo usuário durante a criação da conta. A senha deve ser fornecida em formato criptografado (hash). Isso é útil para automatizar a criação de usuários com senhas predefinidas.

Sintaxe, considerando que vc seja root

    useradd -p encrypted_password username

ou

    useradd --password encrypted_password username

- encrypted_password: A senha criptografada (hash) que será atribuída ao novo usuário.

- username: O nome do usuário que está sendo criado.

#### Gerando a Senha Criptografada
Antes de usar o comando useradd -p, você precisa gerar a senha criptografada. Isso pode ser feito usando o comando openssl passwd ou mkpasswd.

##### Usando openssl passwd

    openssl passwd -6

- -6: Especifica o uso do algoritmo SHA-512 para criptografia.

Digite a senha desejada quando solicitado, e o comando retornará a senha criptografada.

##### Usando mkpasswd (do pacote whois)

    sudo apt-get install whois
    mkpasswd --method=sha-512   

Digite a senha desejada quando solicitado, e o comando retornará a senha criptografada.

#### Exemplo de Uso
Vamos criar um usuário chamado jdoe com a senha password123 (criptografada).

##### Passo 1: Gerar a Senha Criptografada
Usando openssl passwd:

    openssl passwd -6

Digite password123 quando solicitado. A saída será algo como:

    $6$randomsalt$randomhash

##### Passo 2: Criar o Usuário com a Senha Criptografada
Use a senha criptografada gerada no passo anterior:

    sudo useradd -p '$6$randomsalt$randomhash' jdoe

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se a senha foi configurada, você pode usar o comando getent passwd:

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/bash

Para verificar a senha, você pode tentar fazer login como o usuário jdoe ou usar o comando su:

    su - jdoe

Digite password123 quando solicitado.

##### Explicação dos Campos
A linha de saída do comando getent passwd jdoe contém os seguintes campos:

- jdoe: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1001: O UID (User ID) do usuário.

- 1001: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/jdoe: O diretório home do usuário.

- /bin/bash: O shell de login do usuário.

O comando useradd -p ou useradd --password é útil para definir a senha de um novo usuário durante a criação da conta, especialmente em scripts de automação. A senha deve ser fornecida em formato criptografado.

##### OBS
O usuario que foi criado por esse processo, pode ser que vc nao consiga remover ele utilizando o userdel. Ou alterar algo dele utilizando o usermod, por aparecer alguma msg que indique que algo esta em processo. Para isso, vc tera que utilizar o seguinte comando

    ps -ef | grep username

Assim, ele ira exibir todos os PID desse usuario, e vc tera que ir matando o processo uma por uma utilizando o comando

    kill -9 [PID]

### useradd -r ou useradd --system
O comando "useradd -r" ou "useradd --system" é usado para criar uma conta de usuário do sistema. Contas de usuário do sistema são geralmente usadas para serviços e processos do sistema, e não para usuários humanos. Essas contas têm algumas características específicas:

1. UID Baixo: Contas de sistema geralmente têm UIDs (User IDs) baixos, tipicamente abaixo de 1000, dependendo da configuração do sistema. Isso ajuda a diferenciá-las das contas de usuário normais.

2. Sem Diretório Home: Por padrão, contas de sistema não têm um diretório home, a menos que especificado de outra forma.

3. Sem Shell de Login: Contas de sistema geralmente não têm um shell de login, o que significa que não podem ser usadas para fazer login interativo no sistema.

#### Exemplo de Uso
Vamos criar uma conta de sistema para um serviço fictício chamado myservice.

##### Passo 1: Criar a Conta de Sistema

    useradd -r -s /usr/sbin/nologin myservice

- -r ou --system: Indica que estamos criando uma conta de sistema.

- -s /usr/sbin/nologin: Especifica que o shell de login é /usr/sbin/nologin, o que impede logins interativos.

#### Verificando a Configuração
Para verificar se a conta foi criada corretamente, você pode usar o comando getent passwd:

    getent passwd myservice

A saída será algo como:

    myservice:x:999:999::/home/myservice:/usr/sbin/nologin

Aqui, 999 é o UID e GID da conta de sistema, e /usr/sbin/nologin é o shell de login, indicando que a conta não pode ser usada para logins interativos.

##### Explicação dos Campos

- myservice: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 999: O UID (User ID) do usuário.

- 999: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/myservice: O diretório home do usuário (pode ser omitido para contas de sistema).

- /usr/sbin/nologin: O shell de login do usuário, que impede logins interativos.

#### Considerações

- Segurança: Contas de sistema são usadas para rodar serviços e processos com permissões limitadas, aumentando a segurança do sistema.

- Gerenciamento: Manter contas de sistema separadas das contas de usuário normais ajuda na organização e gerenciamento do sistema.

O comando useradd -r ou useradd --system é essencial para criar contas de usuário específicas para serviços e processos do sistema, garantindo que eles operem com permissões apropriadas e sem a capacidade de login interativo.

### useradd -R ou useradd --root (A ABORDAGEM DESSE CONTEUDO FICOU RUIM!! MELHOREEE!!)
O comando "useradd -R" ou "useradd --root" é usado para criar um novo usuário em um ambiente chroot (change root). O chroot é uma operação que muda o diretório raiz aparente para o processo atual e seus filhos. Isso é útil para criar usuários em um sistema de arquivos diferente do sistema de arquivos raiz atual, como em um ambiente de recuperação ou em um sistema de arquivos montado.

Recomendamos que faca isso usando o chroot ([3]) para melhorar a sua seguranca.

#### Utilidade

- Ambientes de Recuperação: Quando você precisa criar ou modificar usuários em um sistema de arquivos que não é o sistema de arquivos raiz atual, como durante a recuperação de um sistema.

- Sistemas de Arquivos Montados: Quando você está preparando um sistema de arquivos para ser usado em outro ambiente, como ao configurar um novo sistema em um disco montado.

- Isolamento: Para criar usuários em um ambiente isolado, onde o diretório raiz é diferente do sistema de arquivos raiz atual.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe em um sistema de arquivos montado em /mnt.

##### Passo 1: Montar o Sistema de Arquivos
Primeiro, vamos monstar um arquivo dentro do diretorio /mnt

    mkdir /mnt/isolated

certifique-se de que o sistema de arquivos está montado em /mnt. Se não estiver, monte-o:

    mount /dev/sdX1 /mnt/isoalted

ou

    mount --bind /dev/null /mnt/isolated

Substitua /dev/sdX1 pelo dispositivo correto (sda, sdb, nvme0n1, hda, sdc1, etc... Escolha a que for mais conveniente. Precisa ser um dispositivo de bloco e, nao, de caracteres. Eu utilizei o "sda").

##### Passo 2: Criar o Usuário no Ambiente chroot
Antes disso, vamos precisar mudar as permissoes de acesso do arquivo passwd que fica em /mnt/isolated/etc/passwd. Pois, ao longo da criacao desse usuario, ele ira ter que realizar alguma escrita sobre esse arquivo.

Use o comando useradd com a opção -R para especificar o novo diretório raiz:

    sudo useradd -R /mnt/isolated -m jdoe

- -R /mnt ou --root /mnt: Especifica o novo diretório raiz.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente, você pode listar o conteúdo do diretório /mnt/etc/passwd:

    cat /mnt/etc/passwd | grep jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/bash

##### Explicação dos Campos

- jdoe: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1001: O UID (User ID) do usuário.

- 1001: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/jdoe: O diretório home do usuário.

- /bin/bash: O shell de login do usuário.

#### Considerações

- Ambientes Isolados: Útil para criar usuários em ambientes isolados, como sistemas de arquivos montados ou ambientes de recuperação.

- Segurança: Permite a criação de usuários em um ambiente controlado, sem afetar o sistema de arquivos raiz atual.

- Flexibilidade: Facilita a configuração de sistemas de arquivos que serão usados em diferentes ambientes ou sistemas.

O comando useradd -R ou useradd --root é uma ferramenta poderosa para administrar usuários em sistemas de arquivos diferentes do sistema de arquivos raiz atual, proporcionando flexibilidade e controle em ambientes de recuperação e preparação de sistemas.

[3]: https://github.com/HelloWounderworld/Linux-Shell-Apache-Master/tree/main/Aprenda-tudo-sobre-o-Linux-Udemy/section06-Gerenciando-contas-usuarios/chroot

### useradd -P ou useradd --prefix (A ABORDAGEM DESSE CONTEUDO FICOU RUIM!! MELHOREEE!!)
O comando "useradd -P" ou "useradd --prefix" é usado para especificar um diretório prefixo onde estão localizados os arquivos de configuração do sistema, como /etc/passwd, /etc/shadow, /etc/group, etc. Isso é útil quando você está gerenciando usuários em um sistema de arquivos diferente do sistema de arquivos raiz atual, como em um ambiente chroot ([3]) ou em um sistema de arquivos montado.

#### Utilidade

- Ambientes de Recuperação: Quando você precisa criar ou modificar usuários em um sistema de arquivos que não é o sistema de arquivos raiz atual, como durante a recuperação de um sistema.

- Sistemas de Arquivos Montados: Quando você está preparando um sistema de arquivos para ser usado em outro ambiente, como ao configurar um novo sistema em um disco montado.

- Isolamento: Para criar usuários em um ambiente isolado, onde o diretório raiz é diferente do sistema de arquivos raiz atual.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe em um sistema de arquivos montado em /mnt.

Primeiro, vamos criar um arquivo dentro do mnt

    mkdir -p /mnt/isolated

##### Passo 1: Montar o Sistema de Arquivos
Primeiro, certifique-se de que o sistema de arquivos está montado em /mnt. Se não estiver, monte-o:

    sudo mount /dev/sdX1 /mnt/isolated

Substitua /dev/sdX1 pelo dispositivo correto.

##### Passo 2: Criar o Usuário no Sistema de Arquivos Montado
Use o comando useradd com a opção -P para especificar o diretório prefixo:

    sudo useradd -P /mnt/isolated -m jdoe

- -P /mnt ou --prefix /mnt: Especifica o diretório prefixo onde estão localizados os arquivos de configuração do sistema.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente, você pode listar o conteúdo do arquivo /mnt/etc/passwd:

    cat /mnt/etc/passwd | grep jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/bash

##### Explicação dos Campos

- jdoe: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1001: O UID (User ID) do usuário.

- 1001: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/jdoe: O diretório home do usuário.

- /bin/bash: O shell de login do usuário.

#### Considerações

- Ambientes Isolados: Útil para criar usuários em ambientes isolados, como sistemas de arquivos montados ou ambientes de recuperação.

- Segurança: Permite a criação de usuários em um ambiente controlado, sem afetar o sistema de arquivos raiz atual.

- Flexibilidade: Facilita a configuração de sistemas de arquivos que serão usados em diferentes ambientes ou sistemas.

O comando useradd -P ou useradd --prefix é uma ferramenta poderosa para administrar usuários em sistemas de arquivos diferentes do sistema de arquivos raiz atual, proporcionando flexibilidade e controle em ambientes de recuperação e preparação de sistemas.

### useradd -s ou useradd --shell
O comando "useradd -s" ou "useradd --shell" é usado para especificar o shell de login padrão para um novo usuário durante a criação da conta. O shell de login é o programa que é executado quando o usuário faz login no sistema. Por padrão, o shell de login é geralmente /bin/bash, mas você pode especificar um shell diferente, como /bin/zsh, /bin/sh, ou qualquer outro shell disponível no sistema.

#### Utilidade

- Personalização: Permite que você configure o ambiente de login do usuário de acordo com suas preferências ou necessidades específicas.

- Segurança: Pode ser usado para restringir o acesso do usuário a um shell específico, como /usr/sbin/nologin, que impede logins interativos.

- Automação: Útil em scripts de automação para garantir que os usuários sejam criados com o shell apropriado sem a necessidade de modificações adicionais.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe e definir seu shell de login para /bin/zsh.

##### Passo 1: Verificar a Disponibilidade do Shell
Primeiro, verifique se o shell desejado está disponível no sistema. Você pode listar os shells disponíveis no arquivo /etc/shells:

    cat /etc/shells

A saída será algo como:

    /bin/sh
    /bin/bash
    /bin/zsh
    /usr/sbin/nologin

##### Passo 2: Criar o Usuário com o Shell Especificado
Use o comando useradd com a opção -s para especificar o shell de login:

    sudo useradd -s /bin/zsh -m jdoe

- -s /bin/zsh ou --shell /bin/zsh: Especifica o shell de login para o novo usuário.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se o shell de login foi configurado, você pode usar o comando getent passwd:

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/zsh

##### Explicação dos Campos

- jdoe: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1001: O UID (User ID) do usuário.

- 1001: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/jdoe: O diretório home do usuário.

- /bin/zsh: O shell de login do usuário.

#### Considerações

- Personalização do Ambiente: Permite que os usuários tenham um ambiente de login que atenda às suas preferências ou necessidades específicas.

- Segurança: Pode ser usado para restringir o acesso do usuário a um shell específico, como /usr/sbin/nologin, que impede logins interativos.

- Automação: Facilita a criação de usuários com o shell apropriado em scripts de automação, garantindo consistência e reduzindo a necessidade de modificações manuais.

O comando "useradd -s" ou "useradd --shell" é uma ferramenta útil para configurar o shell de login de novos usuários, proporcionando flexibilidade e controle sobre o ambiente de login do usuário.

### useradd -u ou useradd --uid
O comando "useradd -u" ou "useradd --uid" é usado para especificar o UID (User ID) de um novo usuário durante a criação da conta. O UID é um número único atribuído a cada usuário no sistema, que é usado para identificar o usuário e determinar suas permissões e propriedade de arquivos.

#### Utilidade

- Controle de UID: Permite que administradores de sistemas atribuam UIDs específicos a novos usuários, garantindo consistência e controle sobre a identificação de usuários.

- Migração de Usuários: Útil ao migrar usuários de um sistema para outro, permitindo que os mesmos UIDs sejam usados para manter a consistência de permissões e propriedade de arquivos.

- Gerenciamento de Permissões: Facilita o gerenciamento de permissões e propriedade de arquivos, especialmente em sistemas com múltiplos usuários e grupos.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe e atribuir a ele o UID 1500.

##### Passo 1: Verificar UIDs Existentes
Antes de criar o novo usuário, é uma boa prática verificar os UIDs existentes para evitar conflitos. Você pode listar os UIDs existentes no sistema usando o comando getent passwd:

    getent passwd

A saída será algo como:

    root:x:0:0:root:/root:/bin/bash
    ...
    existinguser:x:1001:1001::/home/existinguser:/bin/bash
    ...

##### Passo 2: Criar o Usuário com o UID Especificado
Use o comando useradd com a opção -u para especificar o UID:

    sudo useradd -u 1500 -m jdoe

- -u 1500 ou --uid 1500: Especifica o UID para o novo usuário.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se o UID foi configurado, você pode usar o comando getent passwd:

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1500:1500::/home/jdoe:/bin/bash

##### Explicação dos Campos

- jdoe: O nome do usuário.

- x: Indica que a senha está armazenada no arquivo /etc/shadow.

- 1500: O UID (User ID) do usuário.

- 1500: O GID (Group ID) do usuário.

- ::: Campos de GECOS (General Electric Comprehensive Operating System) e diretório home, que estão vazios ou padrão.

- /home/jdoe: O diretório home do usuário.

- /bin/bash: O shell de login do usuário.

#### Considerações

- Controle de UID: Permite que administradores de sistemas atribuam UIDs específicos a novos usuários, garantindo consistência e controle sobre a identificação de usuários.

- Migração de Usuários: Útil ao migrar usuários de um sistema para outro, permitindo que os mesmos UIDs sejam usados para manter a consistência de permissões e propriedade de arquivos.

- Gerenciamento de Permissões: Facilita o gerenciamento de permissões e propriedade de arquivos, especialmente em sistemas com múltiplos usuários e grupos.

O comando useradd -u ou useradd --uid é uma ferramenta essencial para administradores de sistemas que precisam controlar e gerenciar UIDs de usuários, proporcionando flexibilidade e controle sobre a identificação e permissões de usuários no sistema.

### useradd -U ou useradd --user-group
O comando "useradd -U" ou "useradd --user-group" é usado para criar um novo usuário e, ao mesmo tempo, criar um grupo com o mesmo nome do usuário. Este grupo será o grupo primário do usuário. Este comportamento é o padrão em muitas distribuições Linux, mas a opção -U ou --user-group garante explicitamente que o grupo será criado.

#### Utilidade

- Isolamento de Permissões: Criar um grupo com o mesmo nome do usuário ajuda a isolar as permissões de arquivos e diretórios. Isso significa que os arquivos criados pelo usuário terão permissões específicas ao grupo do usuário, evitando conflitos com outros grupos.

- Organização: Facilita a organização e o gerenciamento de permissões, especialmente em sistemas com muitos usuários. Cada usuário tem seu próprio grupo, o que simplifica a atribuição de permissões.

- Segurança: Melhora a segurança ao garantir que os arquivos e diretórios de um usuário não sejam acessíveis por outros usuários, a menos que explicitamente permitido.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe e garantir que um grupo com o mesmo nome seja criado e atribuído como o grupo primário do usuário.

##### Passo 1: Criar o Usuário com o Grupo de Mesmo Nome

    sudo useradd -U -m jdoe

- -U ou --user-group: Garante que um grupo com o mesmo nome do usuário seja criado.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
##### Passo 1: Verificar o Usuário e o Grupo
Use o comando getent passwd para verificar se o usuário foi criado corretamente:

    getent passwd jdoe

A saída será algo como:

    jdoe:x:1001:1001::/home/jdoe:/bin/bash

Aqui, 1001 é o UID (User ID) e o GID (Group ID) do usuário jdoe.

##### Passo 2: Verificar o Grupo
Use o comando getent group para verificar se o grupo foi criado corretamente:

    getent group jdoe

A saída será algo como:

    jdoe:x:1001:

Aqui, 1001 é o GID do grupo jdoe.

##### Passo 3: Verificar as Permissões do Diretório Home
Liste o conteúdo do diretório /home para verificar as permissões do diretório home do usuário:

    ls -ld /home/jdoe

A saída será algo como:

    drwxr-xr-x 2 jdoe jdoe 4096 Jul 12 12:34 /home/jdoe

Aqui, jdoe jdoe indica que o diretório é de propriedade do usuário jdoe e do grupo jdoe.

##### Explicação dos Campos

- drwxr-xr-x: As permissões do diretório.

- 2 jdoe jdoe: O número de links e o proprietário e grupo do diretório.

- 4096 Jul 12 12:34: O tamanho do diretório e a data e hora de criação.

- /home/jdoe: O nome do diretório.

#### Considerações

- Isolamento de Permissões: Cada usuário tem seu próprio grupo, o que ajuda a isolar as permissões de arquivos e diretórios.

- Organização: Facilita a organização e o gerenciamento de permissões em sistemas com muitos usuários.

- Segurança: Melhora a segurança ao garantir que os arquivos e diretórios de um usuário não sejam acessíveis por outros usuários, a menos que explicitamente permitido.

O comando useradd -U ou useradd --user-group é uma ferramenta útil para criar usuários com grupos primários correspondentes, proporcionando flexibilidade e controle sobre a organização e segurança do sistema.

### useradd -Z ou useradd --selinux-user (Verifique melhor esse conteudo pois ficou confuso e nao esta funcionando a explicacao)
O comando useradd -Z ou useradd --selinux-user é usado para especificar um mapeamento de usuário SELinux (Security-Enhanced Linux) para um novo usuário durante a criação da conta. SELinux é um módulo de segurança do Linux que fornece um mecanismo para suportar políticas de segurança obrigatórias. Ele usa contextos de segurança para controlar o acesso a arquivos, processos e outros recursos do sistema.

#### Utilidade

- Segurança Avançada: Permite a aplicação de políticas de segurança mais rigorosas e específicas para usuários individuais, aumentando a segurança do sistema.

- Controle de Acesso: Facilita o controle de acesso baseado em políticas, garantindo que os usuários só possam acessar os recursos que lhes são permitidos.

- Conformidade: Ajuda a garantir que o sistema esteja em conformidade com políticas de segurança organizacionais ou regulatórias.

#### Exemplo de Uso
Vamos criar um novo usuário chamado jdoe e atribuir a ele um mapeamento de usuário SELinux específico.

##### Passo 1: Verificar os Usuários SELinux Disponíveis
Antes de criar o novo usuário, é útil verificar os usuários SELinux disponíveis no sistema. Você pode fazer isso usando o comando semanage:

    semanage user -l

A saída será algo como:

    SELinux User    MLS/MCS Range    Service
    root            s0-s0:c0.c1023   *
    system_u        s0-s0:c0.c1023   *
    user_u          s0               *
    staff_u         s0-s0:c0.c1023   *
    guest_u         s0               *
    xguest_u        s0               *

###### Obs
Caso ocorra o seguinte erro abaixo

    ValueError: SELinux policy is not managed or store cannot be accessed.

Ou o o comando nao foi encontrado, como 

    Command 'semanage'

sera necessario realizar a instalacao

    sudo apt-get install policycoreutils-python-utils

E, alem disso, sera necessario habilitar o SELinux para a consulta. Para isso, precisaria verificar o seguinte

    sestatus

Se aparecer algo como

    SELinux status:                 disabled

Ou seja. indica que sera necessario realizar a sua habilitacao da seguinte forma

    sudo nano /etc/selinux/config

Mude a linha que diz SELINUX=disabled para SELINUX=enforcing ou SELINUX=permissive

    SELINUX=enforcing

Em seguida, reinicie o sistema

    sudo reboot

Novamente, realize a consulta do status

    sestatus

##### Passo 2: Criar o Usuário com o Mapeamento SELinux Especificado
Use o comando useradd com a opção -Z para especificar o mapeamento de usuário SELinux:

    sudo useradd -Z user_u -m jdoe

- -Z user_u ou --selinux-user user_u: Especifica o mapeamento de usuário SELinux para o novo usuário.

- -m: Cria o diretório home para o novo usuário.

#### Verificando a Configuração
Para verificar se o usuário foi criado corretamente e se o mapeamento de usuário SELinux foi configurado, você pode usar o comando semanage login -l:

    semanage login -l | grep jdoe

A saída será algo como:

    jdoe    user_u    s0    *

##### Explicação dos Campos

- jdoe: O nome do usuário.

- user_u: O mapeamento de usuário SELinux atribuído ao usuário.

- s0: O nível de segurança MLS/MCS (Multi-Level Security/Multi-Category Security) atribuído ao usuário.

- *: Indica que o mapeamento é aplicável a todos os serviços.

#### Considerações

- Segurança Avançada: Atribuir mapeamentos de usuário SELinux específicos permite a aplicação de políticas de segurança mais rigorosas e específicas.

- Controle de Acesso: Facilita o controle de acesso baseado em políticas, garantindo que os usuários só possam acessar os recursos que lhes são permitidos.

- Conformidade: Ajuda a garantir que o sistema esteja em conformidade com políticas de segurança organizacionais ou regulatórias.

O comando useradd -Z ou useradd --selinux-user é uma ferramenta poderosa para administradores de sistemas que precisam aplicar políticas de segurança avançadas e específicas para usuários individuais, proporcionando flexibilidade e controle sobre a segurança do sistema.

### useradd --extrausers
O comando useradd --extrausers é usado para criar um novo usuário em sistemas operacionais Linux que utilizam o módulo de autenticação "extrausers" do PAM (Pluggable Authentication Modules).

Vamos entender melhor a utilidade desse comando:

1. Módulo de autenticação "extrausers":

    - O módulo de autenticação "extrausers" do PAM é uma extensão do módulo de autenticação padrão do sistema.

    - Ele permite que os administradores gerenciem usuários e grupos de forma independente do sistema de arquivos padrão (como o /etc/passwd e /etc/group).

    - Isso é útil em ambientes onde você precisa gerenciar usuários e grupos de forma mais flexível, como em sistemas com múltiplos domínios ou em ambientes virtualizados.

2. Utilidade do comando useradd --extrausers:

    - Quando você usa o comando useradd --extrausers, ele cria o novo usuário no módulo de autenticação "extrausers", em vez do sistema de arquivos padrão.

    - Isso significa que o usuário criado não será adicionado aos arquivos /etc/passwd e /etc/group, mas será armazenado em um local diferente, gerenciado pelo módulo "extrausers".

    - Essa abordagem permite que você gerencie os usuários de forma independente do sistema de arquivos padrão, o que pode ser útil em determinados cenários.

#### Exemplo de aplicação:
Imagine que você está administrando um sistema Linux em um ambiente virtual, onde você precisa criar e gerenciar usuários de forma independente do sistema de arquivos padrão. Nesse caso, você pode usar o comando useradd --extrausers para criar os novos usuários.

    sudo useradd --extrausers -m -s /bin/bash newuser

Vamos entender o que cada parte desse comando faz:

- sudo: Executa o comando como superusuário (root), pois a criação de usuários requer permissões elevadas.

- useradd: O comando para criar um novo usuário.

- --extrausers: Indica que o novo usuário deve ser criado no módulo de autenticação "extrausers", em vez do sistema de arquivos padrão.

- -m: Cria um diretório home para o novo usuário.

- -s /bin/bash: Define o shell padrão do usuário como o Bash.

- newuser: O nome do novo usuário que será criado.

Após executar esse comando, o novo usuário "newuser" será criado no módulo de autenticação "extrausers", sem afetar os arquivos /etc/passwd e /etc/group.

Essa abordagem pode ser útil em ambientes virtualizados, em sistemas com múltiplos domínios ou em qualquer situação em que você precise gerenciar os usuários de forma independente do sistema de arquivos padrão.

### Adicionei um usuario novo e quando logo nele nao consigo abrir o FireFox:
Para resolver esse problema vamos ter que ler o seguinte artigo

    https://askubuntu.com/questions/1513839/not-able-to-launch-firefox-on-a-new-user-account

    https://askubuntu.com/questions/1399383/how-to-install-firefox-as-a-traditional-deb-package-without-snap-in-ubuntu-22/1404401#1404401

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

### usermod -b (Conteudo maus explicado... Melhorar)
O comando usermod -b (ou --badnames) é utilizado no Linux para permitir que nomes de usuários que não seguem as convenções padrão sejam aceitos. Isso é útil em situações onde você precisa criar ou modificar usuários com nomes que podem conter caracteres especiais, espaços ou que não são alfanuméricos.

#### Utilidade do Comando usermod -b

- Flexibilidade na Nomenclatura: Permite que administradores de sistema criem nomes de usuários mais descritivos ou que incluam informações adicionais, como nomes completos ou títulos.

- Suporte a Nomes Não Convencionais: Em ambientes onde os nomes de usuários podem precisar ser mais informativos, como em sistemas de gerenciamento de projetos ou em ambientes colaborativos, essa opção é valiosa.

#### Exemplo de Aplicação

##### 1. Criar um Usuário com Nome Inválido
Suponha que você queira criar um usuário chamado "John Doe". Normalmente, nomes de usuários não podem conter espaços. No entanto, usando o --badname, você pode fazer isso:

    sudo useradd --badname "John Doe"

##### 2. Modificar um Usuário Existente
Se você já tem um usuário chamado jdoe e deseja alterar seu nome para "John Doe", você pode usar o seguinte comando:

    sudo usermod -b "John Doe" jdoe

##### 3. Verificar a Alteração
Para verificar se a alteração foi bem-sucedida, você pode usar o comando getent:

    getent passwd jdoe

A saída deve mostrar que o nome do usuário foi alterado para "John Doe".

#### Considerações

- Cuidado com a Segurança: Usar nomes de usuários que não seguem as convenções padrão pode causar problemas de segurança ou de gerenciamento, pois muitos scripts e ferramentas podem não lidar corretamente com esses nomes.

- Compatibilidade: Verifique se o sistema e as aplicações que você está usando suportam nomes de usuários não convencionais.

#### Resumo
O comando usermod -b é uma ferramenta poderosa para administradores de sistemas que precisam de flexibilidade na nomenclatura de usuários. No entanto, deve ser usado com cautela para evitar problemas de compatibilidade e segurança.

### usermod -c (ou --comment)
O comando

    usermod -c or usermod --comment 

é utilizado no Linux para modificar o campo de comentário (ou GECOS) associado a um usuário existente. 

O campo de comentário é um espaço onde você pode armazenar informações adicionais sobre o usuário, como o nome completo, número de telefone, ou qualquer outra informação relevante que ajude a identificar ou descrever o usuário.

#### Utilidade do Comando usermod -c

- Informações Adicionais: Permite que administradores adicionem ou atualizem informações descritivas sobre um usuário, facilitando a identificação e o gerenciamento de contas de usuário.

- Organização: Ajuda a manter um registro organizado de informações sobre os usuários, o que pode ser útil em ambientes com muitos usuários.

- Facilidade de Identificação: O campo de comentário pode ser usado para armazenar o nome completo do usuário, tornando mais fácil a identificação em listas de usuários.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -c "comentário" username

- -c: Indica que você está modificando o campo de comentário.

- "comentário": O novo comentário que você deseja associar ao usuário. Deve ser colocado entre aspas se contiver espaços.

- username: O nome do usuário que você deseja modificar.

#### Exemplo de Aplicação

##### 1. Modificar o Campo de Comentário de um Usuário
Suponha que você tenha um usuário chamado jdoe e queira adicionar o nome completo dele como comentário. Você pode fazer isso com o seguinte comando:

    sudo usermod -c "John Doe - Desenvolvedor" jdoe

##### 2. Verificar a Alteração
Para verificar se a alteração foi bem-sucedida, você pode usar o comando getent:

    getent passwd jdoe

A saída deve mostrar a linha correspondente ao usuário jdoe, incluindo o novo comentário. A saída pode ser semelhante a:

    jdoe:x:1001:1001:John Doe - Desenvolvedor:/home/jdoe:/bin/bash

#### Considerações

- Formato do Comentário: O comentário pode conter espaços e caracteres especiais, mas deve ser colocado entre aspas se contiver espaços.

- Uso em Scripts: O campo de comentário pode ser útil em scripts de automação ou gerenciamento de usuários, onde informações adicionais sobre os usuários são necessárias.

#### Resumo
O comando usermod -c é uma ferramenta útil para administradores de sistemas que desejam adicionar ou modificar informações descritivas sobre usuários. Ele permite que você mantenha um registro organizado e informativo sobre as contas de usuário, facilitando a identificação e o gerenciamento em ambientes multiusuário.

### usermod -d
O comando

    usermod -d
    
é utilizado no Linux para modificar o caminho do diretório home de um usuário existente.

O diretório home é o local onde os arquivos pessoais do usuário são armazenados, e é o diretório padrão que o sistema utiliza quando o usuário faz login.

O comando usermod -d é útil para atualizar o caminho do diretório home de um usuário, especialmente em cenários de reorganização ou migração. Embora não mova os arquivos automaticamente, ele é uma parte importante do processo de gerenciamento de usuários e diretórios no Linux.

#### Utilidade do Comando usermod -d

- Mudança de Localização: Permite que administradores mudem o diretório home de um usuário para um novo local, o que pode ser útil em várias situações, como reorganização de diretórios ou migração de dados.

- Gerenciamento de Espaço: Pode ser usado para mover o diretório home de um usuário para um disco diferente que tenha mais espaço disponível.

- Segurança e Organização: Ajuda a manter os diretórios home em um local específico, que pode ser mais seguro ou mais fácil de gerenciar.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -d novo_diretorio_home username

- -d: Indica que você está modificando o diretório home do usuário.

- novo_diretorio_home: O novo caminho para o diretório home do usuário.

- username: O nome do usuário cujo diretório home você deseja modificar.

#### Exemplo de Aplicação

##### 1. Mudar o caminho do Diretório Home de um Usuário
Suponha que você tenha um usuário chamado jdoe e queira mudar o caminho do seu diretório home de /home/jdoe para /mnt/users/jdoe. Você pode fazer isso com o seguinte comando:

    sudo usermod -d /mnt/users/jdoe jdoe

##### 2. Verificar a Alteração
Para verificar se a alteração foi bem-sucedida, você pode usar o comando getent:

    getent passwd jdoe

A saída deve mostrar a linha correspondente ao usuário jdoe, incluindo o novo diretório home. A saída pode ser semelhante a:

    jdoe:x:1001:1001::/mnt/users/jdoe:/bin/bash

#### Considerações

- Diretório Existente: O novo diretório home deve existir antes de você executar o comando usermod -d. Se o diretório não existir, você precisará criá-lo manualmente usando o comando mkdir.

- Permissões: Certifique-se de que o novo diretório home tenha as permissões corretas para que o usuário possa acessar e modificar seus arquivos.

- Mover Dados: O comando usermod -d não move os arquivos do diretório home antigo para o novo. Se você precisar mover os dados, você terá que fazê-lo manualmente usando comandos como mv.

#### Resumo
O comando usermod -d é uma ferramenta útil para administradores de sistemas que precisam modificar o diretório home de um usuário. Ele permite que os administradores reorganizem a estrutura de diretórios do sistema, gerenciem espaço em disco e mantenham a segurança e a organização dos diretórios home dos usuários.

### usermod -e (ou --expiredate)
O comando
    
    usermod -e

é utilizado no Linux para definir a data de expiração de uma conta de usuário.

Isso significa que, após a data especificada, o usuário não poderá mais fazer login no sistema. Essa funcionalidade é útil em várias situações, como em ambientes de trabalho temporários, contas de usuários que não devem ter acesso contínuo ou para gerenciar contas de usuários que precisam ser desativadas após um certo período.

#### Utilidade do Comando usermod -e

- Gerenciamento de Contas Temporárias: Permite que administradores criem contas de usuários que são válidas apenas por um período específico, facilitando o gerenciamento de acesso.

- Segurança: Ajuda a garantir que contas de usuários que não são mais necessárias sejam desativadas automaticamente, reduzindo o risco de acesso não autorizado.

- Conformidade: Em ambientes regulados, pode ser necessário garantir que contas de usuários sejam desativadas após um certo período, e o comando usermod -e pode ajudar a atender a esses requisitos.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -e YYYY-MM-DD username

- -e: Indica que você está definindo a data de expiração da conta.

- YYYY-MM-DD: A data de expiração no formato ano-mês-dia.

- username: O nome do usuário cuja data de expiração você deseja modificar.

#### Exemplo de Aplicação

##### 1. Definir a Data de Expiração de um Usuário
Suponha que você tenha um usuário chamado tempuser e queira que a conta expire em 30 de setembro de 2023. Você pode fazer isso com o seguinte comando:

    sudo usermod -e 2023-09-30 tempuser

##### 2. Verificar a Alteração
Para verificar se a data de expiração foi definida corretamente, você pode usar o comando chage:

    sudo chage -l tempuser

A saída deve incluir uma linha indicando a data de expiração, como:

    Account expires: 30/09/2023

##### 3. Data que nunca ira expirar
Caso vc queira mudar a data de expieracao da conta de um usuario para que ele nunca expire existem duas formas. Sao elas:

    usermod -e 9999-12-31 username

ou

    usermod -e "" username or usermod -e -1 username

Enquanto na primeira ira mostrar

    Account expires                                         : Dec 31, 9999
    
A segunda ela ira voltar na forma

    Account expires                                         : never

###### Obs
Ou, em algumas distribuições, você pode usar:

    sudo usermod -e 1970-01-01 username

O uso de uma data inválida ou uma data que representa o "início do tempo" pode ser interpretado como "nunca expirar".

###### Alternativa: Usando chage
Outra maneira de definir a expiração da conta para nunca é usando o comando chage diretamente:

    sudo chage -E -1 username

#### Considerações

- Formato da Data: A data deve ser fornecida no formato YYYY-MM-DD. Se a data não for válida, o comando não será executado.

- Desativação da Conta: Após a data de expiração, o usuário não poderá fazer login, mas a conta ainda existirá no sistema. Para remover completamente a conta, você precisaria usar o comando userdel.

- Reativação: Para reativar uma conta expirada, você pode usar o comando usermod -e novamente, definindo uma nova data de expiração ou removendo a data de expiração.

#### Resumo
O comando usermod -e é uma ferramenta útil para administradores de sistemas que precisam gerenciar a validade das contas de usuários. Ele permite que as contas sejam automaticamente desativadas após uma data específica, ajudando a manter a segurança e a conformidade em ambientes de TI.

### usermod -f (ou --inactive)
O comando

    usermod -f
    
é utilizado no Linux para definir o número de dias após a expiração da senha de um usuário antes que a conta seja desativada. 

Isso significa que, se a senha de um usuário expirar, ele terá um período de inatividade (definido em dias) para alterar sua senha antes que a conta seja bloqueada e o usuário não possa mais fazer login.

#### Utilidade do Comando usermod -f

- Gerenciamento de Segurança: Permite que administradores configurem um período de inatividade após a expiração da senha, garantindo que os usuários tenham tempo para atualizar suas credenciais antes que suas contas sejam desativadas.

- Prevenção de Acesso Não Autorizado: Ajuda a evitar que contas permaneçam ativas sem supervisão, forçando os usuários a manterem suas senhas atualizadas.

- Conformidade: Em ambientes regulados, pode ser necessário garantir que as contas sejam desativadas após um certo período de inatividade, e o comando usermod -f pode ajudar a atender a esses requisitos.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -f INACTIVE_DAYS username

- -f: Indica que você está definindo o número de dias de inatividade após a expiração da senha.

- INACTIVE_DAYS: O número de dias após a expiração da senha antes que a conta seja desativada. Se definido como 0, a conta será desativada imediatamente após a expiração da senha.

- username: O nome do usuário cuja configuração de inatividade você deseja modificar.

#### Exemplo de Aplicação

##### 1. Definir o Período de Inatividade
Suponha que você tenha um usuário chamado jdoe e queira definir um período de inatividade de 7 dias após a expiração da senha. Você pode fazer isso com o seguinte comando:

    sudo usermod -f 7 jdoe

##### 2. Verificar a Alteração
Para verificar se a configuração foi aplicada corretamente, você pode usar o comando chage:

    sudo chage -l jdoe or getent shadow jdoe or vipw -s (se tu fizer "sudo vipw -s | grep "username" vai travar...)

A saída deve incluir uma linha indicando o número de dias de inatividade, como:

    Password inactive: 7

#### Considerações
- Valor de INACTIVE_DAYS: Se você definir INACTIVE_DAYS como -1, isso significa que não haverá período de inatividade, e a conta não será desativada após a expiração da senha.

- Interação com a Expiração da Senha: O comando usermod -f funciona em conjunto com a expiração da senha. Portanto, é importante garantir que a expiração da senha esteja configurada corretamente para que o período de inatividade tenha efeito.

#### Resumo
O comando usermod -f é uma ferramenta útil para administradores de sistemas que precisam gerenciar a segurança das contas de usuário. Ele permite que os administradores definam um período de inatividade após a expiração da senha, garantindo que os usuários tenham tempo para atualizar suas credenciais antes que suas contas sejam desativadas.

### usermod -g (ou --gid)
O comando
    
    usermod -g
    
é utilizado no Linux para alterar o grupo primário de um usuário existente.

O grupo primário é o grupo que é associado ao usuário por padrão e é utilizado para determinar as permissões de acesso a arquivos e diretórios. Cada usuário pode pertencer a múltiplos grupos, mas apenas um deles é considerado o grupo primário.

#### Utilidade do Comando usermod -g
- Alteração do Grupo Primário: Permite que administradores mudem o grupo primário de um usuário, o que pode ser necessário em situações de reorganização de grupos ou mudanças nas responsabilidades do usuário.

- Gerenciamento de Permissões: Ao alterar o grupo primário, você pode controlar as permissões de acesso do usuário a arquivos e diretórios que pertencem a esse grupo.

- Organização: Facilita a gestão de usuários e grupos em ambientes onde as funções e responsabilidades dos usuários podem mudar ao longo do tempo.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -g new_group username

- -g: Indica que você está alterando o grupo primário do usuário.

- new_group: O nome ou ID do novo grupo primário que você deseja atribuir ao usuário.

- username: O nome do usuário cujo grupo primário você deseja modificar.

#### Exemplo de Aplicação

##### 1. Alterar o Grupo Primário de um Usuário
Suponha que você tenha um usuário chamado jdoe e queira alterar seu grupo primário para developers. Você pode fazer isso com o seguinte comando:

    sudo usermod -g developers jdoe

Caso seja necessario criar um grupo antes disso bastaria colocar o seguinte comando

    sudo groupadd new_group_name

##### 2. Verificar a Alteração
Para verificar se a alteração foi bem-sucedida, você pode usar o comando id:

    id jdoe

A saída deve mostrar o novo grupo primário do usuário, como:

    uid=1001(jdoe) gid=1002(developers) groups=1002(developers),1003(admins)

#### Considerações
- Grupo Existente:

    O grupo que você está tentando definir como primário deve existir no sistema. Você pode verificar os grupos existentes usando o comando

        getent group

- Permissões: Alterar o grupo primário de um usuário pode afetar suas permissões de acesso a arquivos e diretórios. Certifique-se de que o novo grupo tenha as permissões apropriadas para as tarefas que o usuário precisa realizar.

#### Resumo
O comando usermod -g é uma ferramenta útil para administradores de sistemas que precisam gerenciar a associação de usuários a grupos. Ele permite que os administradores alterem o grupo primário de um usuário, facilitando a administração de permissões e responsabilidades em ambientes multiusuário.

### usermod -G (ou --groups)
O comando

    usermod -G
    
é utilizado no Linux para modificar a lista de grupos suplementares a que um usuário pertence.

Grupos suplementares são grupos adicionais além do grupo primário do usuário, e eles permitem que o usuário tenha permissões de acesso a recursos e arquivos que pertencem a esses grupos.

#### Utilidade do Comando usermod -G
- Gerenciamento de Grupos Suplementares: Permite que administradores adicionem ou removam usuários de grupos suplementares, o que é útil para conceder permissões adicionais sem alterar a associação do usuário ao grupo primário.

- Flexibilidade: Facilita a gestão de permissões em sistemas onde os usuários precisam pertencer a múltiplos grupos para acessar diferentes recursos ou serviços.

- Segurança: Ajuda a manter a segurança do sistema, garantindo que os usuários tenham apenas as permissões necessárias para suas funções.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -G group1,group2,... username

- -G: Indica que você está especificando os grupos suplementares.

- group1,group2,...: Uma lista de grupos aos quais o usuário deve ser adicionado. Os grupos devem ser separados por vírgulas.

- username: O nome do usuário que você deseja modificar.

#### Exemplo de Aplicação

##### 1. Adicionar um Usuário a Grupos Suplementares
Suponha que você tenha um usuário chamado jdoe e queira adicioná-lo aos grupos developers e admins. Você pode fazer isso com o seguinte comando:

    sudo usermod -G developers,admins jdoe

##### 2. Verificar a Alteração
Para verificar se o usuário foi adicionado corretamente aos grupos, você pode usar o comando id:

    id jdoe

A saída deve incluir os grupos aos quais jdoe pertence, como:

    uid=1001(jdoe) gid=1002(jdoe) groups=1002(jdoe),1003(developers),1004(admins)

#### Considerações
- Uso do -a:

    Se você quiser adicionar o usuário a grupos suplementares sem remover o usuário de outros grupos, é crucial usar a opção -a (append) junto com -G. Por exemplo:

        sudo usermod -aG developers,admins jdoe

    Se você usar apenas -G sem -a, o usuário será removido de todos os grupos que não estão listados na opção -G.

- Permissões: Certifique-se de que os grupos aos quais você está adicionando o usuário têm as permissões apropriadas para as tarefas que o usuário precisa realizar.

#### Resumo
O comando usermod -G é uma ferramenta essencial para administradores de sistemas que precisam gerenciar a associação de usuários a grupos de forma eficiente e segura. Ele permite que os usuários mantenham suas associações existentes enquanto recebem novas permissões, facilitando a administração de acesso em ambientes multiusuário.

### usermod -a (ou --append)
Para fornecer permissão sudo (superusuário) para um usuário recém-criado em um sistema Linux, você pode seguir estes passos:

- Abra um terminal ou console como usuário root ou com privilégios de superusuário.

- Edite o arquivo de configuração do sudo, geralmente localizado em /etc/sudoers. Você pode usar um editor de texto como o nano ou vi para fazer as alterações:

        sudo nano /etc/sudoers

- No arquivo /etc/sudoers, localize a seção que contém as linhas de configuração existentes. Geralmente, essa seção começa com a linha # User privilege specification.

- Abaixo dessa seção, adicione uma nova linha com o nome do usuário que você deseja adicionar ao sudoers, seguido da palavra-chave ALL=(ALL:ALL) ALL. Isso concederá ao usuário permissão total para usar o comando sudo.

    Exemplo:

        # User privilege specification
        root    ALL=(ALL:ALL) ALL
        username    ALL=(ALL:ALL) ALL

- Substitua username pelo nome do usuário que você deseja adicionar.

- Salve as alterações e saia do editor de texto.

Alternativamente, você também pode usar o comando visudo para editar o arquivo /etc/sudoers. O visudo é uma ferramenta segura que verifica a sintaxe do arquivo antes de salvá-lo, evitando erros de configuração.

    sudo visudo
    
Após fazer as alterações, salve o arquivo e saia.

Agora, o usuário recém-criado terá permissão sudo e poderá executar comandos com privilégios de superusuário usando o prefixo sudo.

Observação importante: Tenha cuidado ao editar o arquivo /etc/sudoers, pois uma configuração incorreta pode tornar o sistema inacessível. É recomendável fazer backup do arquivo antes de fazer quaisquer alterações.

Você pode conceder permissão sudo a um usuário recém-criado no Linux sem a necessidade de editar diretamente o arquivo /etc/sudoers usando um editor de texto. Você pode fazer isso usando o comando usermod.

O comando 

    usermod -a

é utilizado no Linux para adicionar um usuário a um ou mais grupos suplementares sem removê-lo de outros grupos dos quais ele já faz parte.

A opção -a significa "append" (anexar), e é frequentemente usada em conjunto com a opção -G, que especifica os grupos aos quais o usuário deve ser adicionado.

#### Utilidade do Comando usermod -a

- Gerenciamento de Grupos: Permite que administradores adicionem usuários a grupos suplementares, o que é útil para conceder permissões adicionais sem alterar a associação do usuário a outros grupos.

- Flexibilidade: Facilita a gestão de permissões em sistemas onde os usuários precisam pertencer a múltiplos grupos para acessar diferentes recursos ou serviços.

- Segurança: Ajuda a manter a segurança do sistema, garantindo que os usuários tenham apenas as permissões necessárias para suas funções.

#### Sintaxe
A sintaxe básica do comando é:

    usermod -aG group1,group2,... username

- -a: Adiciona o usuário aos grupos especificados.

- -G: Especifica os grupos suplementares.

- username: O nome do usuário que você deseja modificar.

#### Aqui estão os passos:
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

Observe que, se você quiser remover a permissão sudo de um usuário, basta usar o comando 

    deluser <username> sudo 

para removê-lo do grupo sudo.

#### Exemplo de Aplicação

##### 1. Adicionar um Usuário a Grupos Suplementares
Suponha que você tenha um usuário chamado jdoe e queira adicioná-lo aos grupos developers e admins. Você pode fazer isso com o seguinte comando:

    sudo usermod -aG developers,admins jdoe

##### 2. Verificar a Alteração
Para verificar se o usuário foi adicionado corretamente aos grupos, você pode usar o comando id:

    id jdoe

A saída deve incluir os grupos aos quais jdoe pertence, como:

    uid=1001(jdoe) gid=1001(jdoe) groups=1001(jdoe),1002(developers),1003(admins)

#### Considerações

- Uso do -a: É crucial usar a opção -a ao adicionar grupos. Se você usar apenas -G sem -a, o usuário será removido de todos os grupos que não estão listados na opção -G, o que pode resultar em perda de acesso a recursos.

- Permissões: Certifique-se de que os grupos aos quais você está adicionando o usuário têm as permissões apropriadas para as tarefas que o usuário precisa realizar.

#### Resumo
O comando usermod -a é uma ferramenta essencial para administradores de sistemas que precisam gerenciar a associação de usuários a grupos de forma eficiente e segura. Ele permite que os usuários mantenham suas associações existentes enquanto recebem novas permissões, facilitando a administração de acesso em ambientes multiusuário.

### usermod -h

### usermod -l

### usermod -L

### usermod -m

### usermod -o

### usermod -p

### usermod -R

### usermod -P

### usermod -s

### usermod -u

### usermod -U

### usermod -v

### usermod -V

### usermod -w

### usermod -W

### usermod -Z

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

## Summary
This chapter discussed the command line commands you need to know to manage the Linux security on your system. Linux uses a system of user IDs and group IDs to protect access to files, directories, and devices. Linux stores information about user accounts in the /etc/passwd file and information about groups in the /etc/group file. Each user is assigned a unique numeric user ID, along with a text login name to identify the user in the system. Groups are also assigned unique numerical group IDs and text group names. A group can contain one or more users to allowed shared access to system resources.

Several commands are available for managing user accounts and groups. The useradd command allows you to create new user accounts, and the groupadd command allows you to create new group accounts. To modify an existing user account, use the usermod command. Similarly, use the groupmod command to modify group account information.

Linux uses a complicated system of bits to determine access permissions for fi les and directories. Each fi le contains three security levels of protection: the file’s owner, a default group that has access to the file, and a level for everyone else on the system. Each security level is defined by three access bits: read, write, and execute. The combination of three bits is often referred to by the symbols rwx, for read, write, and execute. If a permission is denied, its symbol is replaced with a dash (such as r-- for read-only permission).

The symbolic permissions are often referred to as octal values, with the three bits combined into one octal value and three octal values representing the three security levels. Use the umask command to set the default security settings for fi les and directories created on the system. The system administrator normally sets a default umask value in the /etc/profile fi le, but you can use the umask command to change your umask value at any time.

Use the chmod command to change security settings for files and directories. Only the file’s owner can change permissions for a file or directory. However, the root user can change the security settings for any file or directory on the system. You can use the chown and chgrp commands to change the default owner and group of the file.

The chapter closed with a discussion on how to use the set GID bit to create a shared directory. The SGID bit forces any new files or directories created in a directory to use the default group name of the parent directory, not that of the user who created them. This provides an easy way to share files between users on the system.

Now that you’re up to speed with file permissions, it’s time to take a closer look at how to work with the actual file system in Linux. The next chapter shows you how to create new partitions in Linux from the command line and then how to format the new partitions so that they can be used in the Linux virtual directory.

## Key points
