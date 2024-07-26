#!/bin/bash
# testing the read command
#
# cat test
line="Wounerworld!"
while [ $line != "exit" ]
do
    read line
    echo "Hello $line, welcome to my program."
done
#