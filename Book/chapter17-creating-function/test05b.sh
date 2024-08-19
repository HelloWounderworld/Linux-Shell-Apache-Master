#!/bin/bash
# using the return command in a function

function dbl {
    read -p "Enter a value: " value
    echo $[ $value * 2 ]
}

result=$(dbl)
echo "The new value is $result"
