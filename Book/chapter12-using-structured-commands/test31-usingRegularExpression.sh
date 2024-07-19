#!/bin/bash
# using pattern matching
#
if [[ $USER == r* || $USER == t* ]]
then
    echo "Hello $USER"
else
    echo "Sorry, I do not know you"
fi