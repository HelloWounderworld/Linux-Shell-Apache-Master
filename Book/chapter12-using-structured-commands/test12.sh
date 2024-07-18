#!/bin/bash
# testing string equality
#
testuser=teramatsu
#
if [ $USER = $testuser ]
then
    echo "Welcome $testuser"
fi