# Gerenciando Grupos:
- cat /etc/group - Serve para verificar quais grupos compostos de usuários existem.

- Todo usuário criado pelo useradd acabam sendo adicionados aos grupos primários ou secundários.

- groups (nome de algum grupo) - Mostrará todos os usuários pertencentes à esse grupo.

- groupadd (nome do grupo novo) - Criará um novo grupo.

- usermod -G (nome do grupo) (usuário que vc quer add) - Serve para adicionar um usuário em um determinado grupo.

- groups (nome do usuário) - Mostrará em quais groups esse usuário pertence.