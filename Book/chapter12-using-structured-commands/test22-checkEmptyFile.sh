#!/bin/bash
# Testing if a file is empty
#
# file_name=$HOME/sayHello.txt
# file_name="/home/teramatsu/sayHello.txt"
file_name="/home/teramatsu/emptyfile.txt"
touch "/home/teramatsu/emptyfile.txt"
#
if [ -f $file_name ]
then
    if [ -s $file_name ]
    then
        echo "The $file_name file exists and has data in it."
        echo "Will not remove this file."
#
    else
        echo "The $file_name file exists, but is empty."
        echo "Deleting empty file..."
        rm $file_name
    fi
else
    echo "File, $file_name, does not exist."
fi
#