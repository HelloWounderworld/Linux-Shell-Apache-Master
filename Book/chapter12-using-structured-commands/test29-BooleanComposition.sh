#!/bin/bash
# testing compound comparisons
# AND: &&
# OR: ||
#
echo "This is the home: $HOME"
if [ -d $HOME ] && [ -w $HOME/.profile ]
then
    echo "The file exists and you can write to it"
else
    echo "I cannot write to the file"
fi