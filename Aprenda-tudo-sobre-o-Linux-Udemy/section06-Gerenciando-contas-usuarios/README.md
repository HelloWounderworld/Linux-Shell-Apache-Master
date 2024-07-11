# Secao 06: Gerenciando contas de usuarios

## Criando contas de usuários
O "useradd" serve para adicionar algum novo usuário e não basta somente esse comando, mas se quiser verificar as opcoes do que ele e possivel bastaria colocar

    useradd

Mas tbm, precisaria colocar mais algum outro comando. Para verificar isso basta colocar useradd no terminal e dar o enter.

    useradd -m '[some name]'
    
cria o usuário com o nome. Mas vc consegue fazer isso mediante de que vc seja o root.

Existem varias formas de adicionar os usuarios, vamos explorar todas elas:

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

### 

###

###

###

###

###

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

### Utilizando o -a
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
