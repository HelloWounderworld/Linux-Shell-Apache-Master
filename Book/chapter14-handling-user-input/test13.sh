#!/bin/bash
# demonstrating the shift command
# Be careful when working with the shift command. When a parameter is shifted out, its value is lost and can’t be recovered.
# ./test13.sh rich barbara katie jessica
#
echo
count=1
while [ -n "$1" ]
do  
    echo "Parameter #$count = $1"
    count=$[ $count + 1 ]
    shift
done
echo