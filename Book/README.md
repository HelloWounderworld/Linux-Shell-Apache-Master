# Formas de estudo

## Windows:
Irei realizar o estudo desse livro pela OS Windows11. Logo, recomendo o usuario utilizar o WSL para instalar o linux dentro dela para realizar os devidos estudos necessarios.

### Maneiras de estudar
E possivel utilizar a IDE como VSCode ou Cursor, para abrir o diretorio, remotamente, do WSL na IDE. Bastaria utilizar as seguintes extensoes:

- Remote - SSH

- Remote - SSH: Editing Configuration File

- Remote Explorer

Assim, vc conseguira acessar os diretorios do WSL diretamente das IDE's.

#### OBS
Existem casos em que quando vc copia e cola um determinado arquivo shell script, mesmo depois que vc fornece as permissoes de execucao, por algum motivo, nao ocorre a tal execucao e o sistema indica que o arquivo, que esta presente, nao se encontra. Para resolver esse problema vc poderia utilizar o seguinte comando

    dos2unix nomedoarquivo.sh

Isso ira permitir que seja encontrado o arquivo que foi enviado.
