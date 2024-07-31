#!/bin/bash
# Test running in the background with output
#
# ./test5.sh &
#
echo "Start the test script"
count=1
while [ $count -le 5 ]; do
    echo "Loop #$count"
    sleep 5
    count=$[ $count + 1 ]
done
#
echo "Test script is complete"
#