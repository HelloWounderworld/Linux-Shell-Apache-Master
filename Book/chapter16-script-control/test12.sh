#!/bin/bash
# Test job control
#
# ./test11.sh
# Ctrl + Z
# ./test12.sh
# Ctrl + Z
# bg [job number] # restart the job in background mode
# jobs
#
# ./test12.sh
# Ctrl + Z
# fg [number job] # restart the job in foreground mode - O prompt de comando so ira aparecer depois que o shell terminar de executar, visto que ele esta executando no primeiro plano
#
echo "Test12.sh - Start"
echo "Script process ID: $$"
#
count=1
while [ $count -le 10 ]; do
    # echo "Loop #$count"
    sleep 3
    count=$[ $count + 1 ]
done
#
echo "End of script..."
#