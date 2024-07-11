# Vamos praticar alguns comandos:

- Primeiro, vamos verificar quais tipos de containers estão rodando no docker ou quantos containers foram criadas, o que inclui aquelas que não estão rodando mas estão lá, claro precisa estar com o Docker Desktop aberto:

        docker ps
    
    serve para verificar quais containers estão rodando.

        docker ps -a
    
    Lista todos os containers existentes.

- Segundo, vamos pegar a distribuição Linux do Docker Hub rodando o comando pelo terminal. Vale ressaltar que a forma como será rodado o Ubuntu se chama modo interativo (interactive mode):
    
        docker run -it (nome da ditribuição, neste caso, apenas, "ubuntu")
        
    Não só baixa a distribuição como tbm já roda criando um terminal linux Ubuntu dentro do terminal que vc está utilizando

        Unable to find image 'ubuntu:latest' locally
        latest: Pulling from library/ubuntu
        cf92e523b49e: Pull complete 
        Digest: sha256:35fb073f9e56eb84041b0745cb714eff0f7b225ea9e024f703cab56aaa5c7720
        Status: Downloaded newer image for ubuntu:latest
        root@afd2ee4370ef:/#

Exibição do resultado após rodar o comando acima. Basicamete, "root@afd2ee4370ef:/#" isso indica que está rodando um terminal linux Ubuntu dentro do terminal que vc está trabalhando.

Claro, vc poderia apenas baixar o ubuntu tbm fazendo

    docker pull ubuntu

Para confirmação disso, bastaria colocar o comando "ls" nesse terminal Linux para verificar que serão exibidos diretórios que não constam na sua máquina.