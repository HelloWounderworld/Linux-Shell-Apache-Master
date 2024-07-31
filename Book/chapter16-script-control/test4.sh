#!/bin/bash
# Test running in the background
#
# ./test4.sh &
#
count=1
while [ $count -le 10 ]; do
    sleep 1
    count=$[ $count + 1 ]
done
#