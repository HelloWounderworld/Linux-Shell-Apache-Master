# Secao 06: Gerenciando contas de usuarios

## Criando contas de usuários
O "useradd" serve para adicionar algum novo usuário e não basta somente esse comando, mas se quiser verificar as opcoes do que ele e possivel bastaria colocar

    useradd

Mas tbm, precisaria colocar mais algum outro comando. Para verificar isso basta colocar useradd no terminal e dar o enter.

    useradd -m '[some name]'
    
cria o usuário com o nome. Mas vc consegue fazer isso mediante de que vc seja o root.

## Alterando usuários
O "usermod" serve para modificar algum usuario ja existente.

    usermod

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

## Locais para verificar os usuarios e suas permissoes

    cat /etc/passwd
    
Serve para verificar se o usuário foi criado, mas claro, o password será exibido de forma encriptada.

Um outro lugar para vericarmos se algum usuario foi logado de forma bem sucedida sendo o root seria em seguinte

    cat /etc/shadow

## Gerenciando as contas de grupo
