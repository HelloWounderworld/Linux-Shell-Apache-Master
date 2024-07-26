#!/bin/bash
# redirecting input file descriptors - Mesma logica do SDTOUT
#
# ./test15.sh
#

exec 0<testfile

count=1
while read line
do
    echo "Line #$count: $line"
    count=$[ $count + 1 ]
done

exec 0</dev/pts/2
