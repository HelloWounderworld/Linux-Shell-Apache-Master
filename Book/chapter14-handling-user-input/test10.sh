#!/bin/bash
# Grabbing the last parameter
# bash test10.sh 1 2 3 4 5
# bash test10.sh
#
params=$#
echo
echo The last parameter is $params
echo The last parameter is ${!#}
echo