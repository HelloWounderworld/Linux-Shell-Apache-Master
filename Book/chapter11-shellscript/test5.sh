#!/bin/bash
testing1=`date`
testing2=$(date)
echo "The data1 and time are: " $testing1
echo "The data2 and time are: " $testing2

# copy the /usr/bin directory listing to a log file
# ira gerar um arquivo log.240716 mostrando todos os diretorios dentro do diretorio bin com a suas devidas permissoes
today=$(date +%y%m%d)
ls /usr/bin -al > log.$today
