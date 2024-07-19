#!/bin/bash
# using pattern matching
# Double brackets work fine in the bash shell. Be aware, however, that not all shells support double brackets.
#
if [[ $USER == r* || $USER == t* ]]
then
    echo "Hello $USER"
else
    echo "Sorry, I do not know you"
fi