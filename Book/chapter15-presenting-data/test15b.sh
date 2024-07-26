#!/bin/bash
# redirecting input file descriptors
#
# ./test15.sh
#

exec 6<testfile

count=1
while read line<&6
do
    echo "Line #$count: $line"
    count=$[ $count + 1 ]
done
