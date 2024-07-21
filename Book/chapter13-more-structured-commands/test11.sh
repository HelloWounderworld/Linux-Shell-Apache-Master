#!/bin/bash
# testing the C-style for loop

for (( a=1, b=10; a <= 10; a++, b-- ))
do
    echo "The next number is $a - $b"
done