#!/bin/bash
# Test job control
#
# ./test10.sh
# ./test10.sh > test10.out &
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