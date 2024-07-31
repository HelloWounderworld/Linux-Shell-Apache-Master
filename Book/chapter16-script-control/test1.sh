#!/bin/bash
# Testing signal trapping
# ./test1.sh
# Vai batendo na tecla "Ctrl + C"
#
# nohup ./test1.sh & # Maneira de fazer o processo continuar rodando mesmo depois que vc fecha o terminal, no segundo plano
#
trap "echo ' Sorry! I have trapped Ctrl-C'" SIGINT
#
echo This is a test script
#
count=1
while [ $count -le 10 ]
do
    echo "Loop #$count"
    sleep 5
    count=$[ $count + 1 ]
done
#
echo "This is the end of the test script"
#