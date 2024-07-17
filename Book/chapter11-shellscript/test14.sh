#!/bin/bash
# testing the exit status
var1=10
var2=30
var3=$[$var1 + $var2]
echo The answer is $var3
echo $?
# Aqui abaixo vc criou o seu proprio status de de saida.
# Depois que vc rodar o script, ao digitar no terminal "echo $?"
# se o processo finalizou de forma bem sucedida vc conseguira ver o valor "5"
# que e o que esta definido abaixo
exit 5