#!/bin/bash
# reading values from a file, states.txt

file="states.txt"

for state in $(cat $file)
do
    echo "Visit beautiful $state"
done