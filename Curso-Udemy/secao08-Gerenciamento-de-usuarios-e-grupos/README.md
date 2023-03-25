# Seção 08 - Gerenciamento de usuários e grupos:

## Aula 01 - Introdução

## Aula 02 - Adicionando usuários no Linux
Para criar um usuário

    sudo adduser (nome do usuário)

Em seguida, ele irá pedir a senha (e repetir a mesma) para depois pedir para colocar o nome completo e outras informações. Caso vc não queira colocar outras informações, pode deixar em branco, apenas vai teclando enter. Assim, vai te perguntar, no final, se está tudo ok com as informações acima, então vc tecla sim.

Para ver se tem outro usuário que foi criado bastaria dar

    ls /home/

Exibirá todos os usuários residentes dentro da máquina.

No caso, como vc poderia se conectar com o outro usuário. Apenas dando um logout da sua máquina, que isso irá exibir um outro usuário que vc criou nesse processo e bastaria vc logar nesse outro usuário com a senha que vc definiu no processo acima.

## Aula 03 - Deletando usuários
Agora, para deletar esse usuário que foi criado, bastaria dar o logout dele e entrar no seu usuário adm e, em seguida, no terminal vc realiza o seguinte comando

    sudo userdel --remove (nome do usuário)

## Aula 04 - Mudando o nome de Display do usuário
Criado o usuário, para modificar o nome do usuário tem que fazer o seguinte

    sudo usermod -c '(nome novo)' (nome do usuário que vc quer alterar)

Mas esse comando vai mudar o nome do usuário apenas na parte gráfica. Ou seja, o nome que aparece no login.

## Aula 05 - Mudando o nome do diretório base e do usuário no terminal
Para alterar o nome do diretório base de um usuário existente 

    sudo usermod -l (nome novo) -d /home/(nome novo) -m (nome antigo que será substituído)

## Aula 06 - Bloqueando e desbloqueando usuários
Para desabilitar um usuário e não deletar

    sudo usermod -L (nome do usuário que vc quer desabilitar)

Ela estará bloqueada e nem nos logins vai aparecer mais o nome dela, mas o diretório dela ainda estará presente.

Agora, para desbloquear o usuário

    sudo usermod -U (nome do usuário que vc quer desbloquear)

## Aula 07 - O que é um grupo no Linux?
Facilita o gerenciamento de um conjunto de usuários colocando as mesmas habilitações em todas elas.

## Aula 08 - Criando grupos no Linux
Para visualizar todos os grupos existentes ou criados

    getent group

Isso listará todos os grupos que foi criado.

Para add um grupo

    sudo groupadd -g (algum número inexistente dentro da lista) (nome do grupo)

## Aula 09 - Deletando um grupo
Para deletar um grupo

    sudo groupdel (nome do grupo que vc quer deletar)

## Aula 10 - Movendo um usuário para outro grupo
Pare verificar em quais usuários existem dentro de um grupo

    groups (nome do grupo)

Isso listará todos os grupos em que esse usuário pertence.

Para colocar um usuário dentro de um grupo

    sudo usermod -a -G (nome do usuario) (nome do grupo)

Para remover um usuário de um grupo

    sudo gpasswd -d (nome do grupo) (nome do usuário)

## Aula 11 - Dica: como virar um super usuário
Vamos virar o super usuário

    sudo su

ou 

    sudo -u

Daí, vc virará o adm, root, ou seja, todo poder estará em suas mãos. Qualquer comando vc poderá fazer sem usar o sudo.

Para sair disso

    exit

## Aula 12 - Dica: trocando a senha do usuário
Para trocar a senha do usuário atual

    passwd

Pedirá a senha atual e depois pedirá a senha nova (pedirá para repetir a mesma).

Feito isso, sempre que vc logar na sua máquina, vc usará essa senha nova alterada.
