#!/bin/bash
# Test job control
#
# ./test10.sh
# ./test10.sh > test10.out & # Ele so vai iniciar um outro processo, mas enviando a saida, que seria exibido normalmente na tela, dentro desse arquivo test10.out, rodando em segundo plano
# jobs
# jobs -l
#
# ./test10.sh > test10a.out &
# ./test10.sh > test10b.out &
# ./test10.sh > test10c.out &
# jobs -l
# kill [PID]
# jobs -l
# kill [PID]
# jobs -l
#
echo "Script process ID: $$"
#
count=1
while [ $count -le 10 ]; do
    echo "Loop #$count"
    sleep 10
    count=$[ $count + 1 ]
done
#
echo "End of script..."
#