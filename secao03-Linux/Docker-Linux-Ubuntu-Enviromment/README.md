# Commands to handle container

## Build:

    docker build -t my-linux-enviromment .

## Run:

    docker run -it my-linux-enviromment

## To see containers:
Active containers

    docker ps

All containers

    docker ps -a

## To remove docker images:

    docker rmi imagem1 imagem2 imagem3

    docker rmi id_da_imagem1 id_da_imagem2 id_da_imagem3

## To enter inside a container

    docker exec -it '[container ID]' sh 

or

    docker exec -it '[container ID]' /bin/bash

or

    docker exec -it '[container ID]' bash

### Access with user created by useradd

    docker exec -it -u '[user name]' '[container ID]' sh

or

    docker exec -it -u '[user name]' '[container ID]' /bin/bash

or

    docker exec -it -u '[user name]' '[container ID]' bash
