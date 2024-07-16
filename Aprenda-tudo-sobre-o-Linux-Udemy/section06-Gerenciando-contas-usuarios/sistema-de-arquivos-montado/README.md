# Sistema de Arquivos Montado
Um Sistema de Arquivos Montado (Mounted File System) é um conceito fundamental no gerenciamento de arquivos e diretórios em sistemas operacionais, especialmente em sistemas baseados em Unix, como Linux e macOS.

Basicamente, um sistema de arquivos montado refere-se à associação de um dispositivo de armazenamento (como um disco rígido, unidade USB, partição de disco, etc.) a um ponto de montagem específico na hierarquia de diretórios do sistema operacional.

Vamos entender melhor:

1. Hierarquia de Diretórios:

    - Nos sistemas Unix-like, a estrutura de diretórios é organizada de forma hierárquica, começando no diretório raiz (/).

    - Todos os outros diretórios e arquivos são organizados dentro dessa estrutura hierárquica.

2. Pontos de Montagem:

    - Um ponto de montagem é um diretório específico na hierarquia de diretórios onde um sistema de arquivos é "montado".

    - Quando um sistema de arquivos é montado em um ponto de montagem, o conteúdo desse sistema de arquivos torna-se acessível a partir desse ponto de montagem.

3. Montagem de Sistemas de Arquivos:

    - Quando um sistema operacional inicializa, ele monta automaticamente alguns sistemas de arquivos essenciais, como o sistema de arquivos raiz (/), o sistema de arquivos /proc (que fornece informações sobre o sistema) e outros.

    - Além disso, o usuário ou o administrador do sistema pode montar manualmente outros sistemas de arquivos em pontos de montagem específicos.

4. Exemplos de Montagem:

    - Imagine que você tenha uma partição de disco separada para armazenar seus arquivos pessoais. Você pode montar essa partição em um ponto de montagem, como /home/usuario.

    - Ou então, você pode montar uma unidade USB em um ponto de montagem, como /mnt/usb, para acessar os arquivos armazenados nela.

5. Benefícios da Montagem:

    - A montagem de sistemas de arquivos permite que o sistema operacional organize e gerencie os diferentes dispositivos de armazenamento de forma unificada.

    - Isso facilita a navegação e o acesso aos arquivos, independentemente de onde eles estão fisicamente armazenados.

    - Também permite a separação e a organização dos dados em diferentes partições ou dispositivos, melhorando a segurança e a gestão do sistema.

Em resumo, um sistema de arquivos montado é a associação de um dispositivo de armazenamento a um ponto de montagem específico na hierarquia de diretórios do sistema operacional, permitindo que os usuários acessem e gerenciem os arquivos de forma organizada e unificada.

Seguir links para leitura:

    https://www.linode.com/docs/guides/mount-file-system-on-linux/

    https://www.geeksforgeeks.org/mount-command-in-linux-with-examples/

    https://linuxize.com/post/how-to-mount-and-unmount-file-systems-in-linux/