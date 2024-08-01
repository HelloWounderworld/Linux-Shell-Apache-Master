#!/bin/bash
# Test running in the background
#
# ./test4.sh &
#
# nice -n 10 ./test4.sh > test4.out &
# ps -p [PID] -o pid,ppid,ni,cmd
# nice -n -10 ./test4.sh > test4.out &
#
count=1
while [ $count -le 10 ]; do
    sleep 1
    count=$[ $count + 1 ]
done
#