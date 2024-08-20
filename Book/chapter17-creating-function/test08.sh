#!/bin/bash
# using a global variable to pass a value
#
# ./test08.sh
#

function dbl {
    value=$[ $value * 2 ]
}

read -p "Enter a value: " value
echo "Variable before: $value"
dbl
echo "The new value is: $value"
