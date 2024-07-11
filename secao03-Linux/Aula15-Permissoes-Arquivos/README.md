# Permissões de Arquivos: 

## Verificando as permissoes
Quando digitamos

    ls -l
    
na lista é mostrado uma combinação de "r", "w", "d" e "x", respectivamente:

- r: read

- w: write

- d: directory

- x: execute

Eles indicam os tipos de permissões que o usuário pode realizar sobre o arquivo, diretório e o programa que existem.

### Como ler as permissoes
Vamos pegar um exemplo

    drwxr-xr-x 5 leonardo leonardo 4096 Jul  8 21:25 git

No caso, pegando o exemplo de permissao acima, ela e dividido da seguinte forma

                d                                  rwx                   r-x                    r-x             leonardo        leonardo
    (diretorio ou arquivo: d/-)         (Permissoes do usuario)        (Grupo)          (Everyone - O resto)    (Usuario)       (Grupo)

Ou seja, dividimos em blocos:

- diretorio ou arquivo:

    Onde esta escrito "d", ele indica que e um diretorio. Caso contrario, ele sera um arquivo e estara sendo representado como "-"

- Primeiro bloco: Permissao de usuario

    O primeiro bloco, indica as permissoes de usuario. No exemplo acima, ela esta como o seguinte

        rwx

    Ou seja, isso indica o que o usuario tem de permissao.

    No caso, indica que ele tem a permissao de leitura (r), escrita (w) e execucao (x).

- Segundo bloco: Grupo de usuarios

    O segundo bloco, ele indica as permissoes que o grupo de usuarios tem de permissoes.

    No caso, no exemplo acima, ele esta da seguinte forma

        r-x

    Ou seja, indica que o grupo ele tem a permissao de leitura (r), mas nao tem a permissoa de escrita (w), mas tem a permissoa de executar (x).

- Terceiro bloco: Everyone

    O terceiro bloco indica todo o restante. Ou seja, que nao seja usuario e que nao seja um grupo. Que tipo de permissoa ele tem. No exemplo acima, temos o seguinte



Obs: Existem casos em que vc verifica que o usuario ele tem todas as permissoes de acesso, porem numa determinada exibicao, tais permissoes nao aparecem. Isso nao quer dizer que o sistema esta te enganando e que o usuario que tem tal permissoa total nao tenha a permissao. Depennde do arquivo ou diretorio, pois existem arquivos que podem ser lido e escrito, mas nao e um arquivo de programa e, sim, um arquivo texto. Nao faz sentido um arquivo texto ser executavel, mesmo que o usario tenha total permissao.

## chmod

    chmod u+'[some permission]' '[file that you want to add permission]'
    
Serve para add alguma permissão de um usuário sobre um arquivo.

## chown
Certainly! The chown command in Linux is used to change the ownership of a file or directory. It stands for "change owner" and is a powerful tool for managing file permissions and access control.

Here's a more detailed explanation of the chown command:

### Functionality:
The chown command allows you to change the user and/or group ownership of a file or directory. This is important because file ownership determines who has access to the file and what operations they can perform on it.

### Syntax:
The basic syntax for the chown command is as follows:

    chown [options] owner[:group] file_or_directory

- owner: The new user owner of the file or directory.

- group: The new group owner of the file or directory (optional).

- file_or_directory: The file or directory whose ownership needs to be changed.

### Options:
The chown command supports several options that can modify its behavior:

-R: Recursively change the ownership of files and directories inside a directory.

-c: Display a message for each file whose ownership is changed.

-h: Change the ownership of a symbolic link itself, rather than the file or directory it points to.

-v: Display verbose output, showing the files whose ownership is changed.

--reference=RFILE: Use the owner and group of the RFILE as the reference.

### Examples:

#### Change the owner of a file:
Change the owner of a file:

    chown user1 file.txt

This changes the owner of file.txt to the user user1.

#### Change the owner and group of a file:
Change the owner and group of a file:

    chown user1:group1 file.txt

This changes the owner to user1 and the group to group1 for file.txt.

#### Recursively change the ownership
Recursively change the ownership of a directory and its contents:

    chown -R user1:group1 /path/to/directory

This changes the owner to user1 and the group to group1 for the directory /path/to/directory and all its files and subdirectories.

#### Change the ownership of a symbolic link
Change the ownership of a symbolic link:

    chown -h user1 symlink.txt

This changes the owner of the symbolic link symlink.txt to user1, without affecting the ownership of the file it points to.

### Importance:
Proper file ownership management is crucial in Linux systems, as it determines the access and permissions for different users and groups. The chown command allows system administrators and users to effectively control who can access and modify files and directories, which is essential for maintaining system security and data integrity.

By understanding and using the chown command effectively, you can ensure that your Linux system's files and directories have the appropriate ownership, which is a key aspect of file and directory permissions management.