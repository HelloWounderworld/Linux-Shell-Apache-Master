#!/bin/bash
# Look before you leap
#
jump_directory=/home/teramatsu
#
if [ -d $jump_directory ]
then
    echo "The $jump_directory directory exists"
    cd $jump_directory
    ls -l
else
    echo "The $jump_directory directory does not exist"
fi
#
