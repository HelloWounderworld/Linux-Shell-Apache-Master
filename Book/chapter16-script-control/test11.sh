#!/bin/bash
# Test job control
#
# ./test11.sh
# Ctrl + Z
# bg # restart the job in background mode
# jobs
#
# ./test11.sh &
# ps -p [PID] -o pid,ppid,ni,cmd
# renice -n 10 -p [PID] # Altera a prioridade do agendamento de um comando ja em execucao
# ps -p [PID] -o pid,ppid,ni,cmd
#
echo "Test11.sh - Start"
echo "Script process ID: $$"
#
count=1
while [ $count -le 10 ]; do
    # echo "Loop #$count"
    sleep 10
    count=$[ $count + 1 ]
done
#
echo "End of script..."
#