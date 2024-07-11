# Gerenciando Grupos:

## Verificacao de grupos composot de usuarios

    cat /etc/group
    
Serve para verificar quais grupos compostos de usuários existem.

Todo usuário criado pelo useradd acabam sendo adicionados aos grupos primários ou secundários.

## groups

    groups (nome de algum grupo)
    
Mostrará todos os usuários pertencentes à esse grupo.

    groups (nome do usuário)
    
Mostrará em quais groups esse usuário pertence.

## groupadd

    groupadd (nome do grupo novo)
    
Criará um novo grupo.

## groupmod

## groupdel

## usermod -G

    usermod -G '[groups name]' '[user name that you want to add]'
    
Serve para adicionar um usuário em um determinado grupo.