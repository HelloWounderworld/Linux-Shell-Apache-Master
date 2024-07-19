#!/bin/bash
# reading values from a file, states.txt

file="states.txt"

IFS=$'\n'

for state in $(cat $file)
do
    echo "Visit beautiful $state"
done

echo

# IFS.OLD=$IFS
IFS=$' '
for state in $(cat $file)
do
    echo "Visit beautiful $state"
done
IFS=$IFS.OLD

# IFS.OLD=$IFS
# IFS=$'\n':;"
IFS=:

for state in $(cat $file)
do
    echo "Visit beautiful $state"
done
IFS=$IFS.OLD
