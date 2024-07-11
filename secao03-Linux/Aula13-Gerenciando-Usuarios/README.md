# Gerenciando Usuários:
- useradd - Serve para poder add algum novo usuário e não basta somente esse comando. Mas tbm, precisaria colocar mais algum outro comando. Para verificar isso basta colocar useradd no terminal e dar o enter.

- useradd -m (algum nome) - cria o usuário com o nome. Mas vc consegue fazer isso mediante de que vc seja o root.

- usermod - serve para modificar o usuário.

- userdel - serve para deletar o usuário.

- cat /etc/passwd - Serve para verificar se o usuário foi criado, mas claro, o password será exibido de forma encriptada.

- Precisamos saber como logar com o usuário que criamos dentro do SO interativo. Para isso precisamos abrir uma nova aba do terminal e dentro dela digitar "docker exec -it -u (nome do usuário criado) (Id do container onde está rodando o SO interativo) bash".

- Ao logarmos com um usuário, ele terá alguns acessos negados, onde somente o usuário dono "root" tem.

- exit - Para sair do modo de usuário logado.