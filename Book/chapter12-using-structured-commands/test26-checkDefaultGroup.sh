#!/bin/bash
# check file group test
#
# if [ -G $HOME/testing ]
if [ -G "/home/teramatsu/sayHello.txt" ]
then
    echo "You are in the same group as the file"
else
    echo "The file is not owned by your group"
fi

# Usuario atual (a que vai executar o script)
if id -nG | grep -q "root"; then
    echo "O usuário pertence ao grupo 'root'"
else
    echo "O usuário não pertence ao grupo 'root'"
fi

# Verificando para usuario relativo
username="teramatsu"
if id -nG $username | grep -q "root"; then
    echo "O usuário 'username' pertence ao grupo 'root'"
else
    echo "O usuário 'username' não pertence ao grupo 'root'"
fi