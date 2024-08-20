#!/bin/bash
# trying to access script parameters inside a function
#
# ./test07.sh
#
# ./test07.sh 10 15
#

function func7 {
    echo $[ $1 * $2 ]
}

if [ $# -eq 2 ]
then
    value=$(func7 $1 $2)
    echo "The result is $value"
else
    echo "Usage: badtest1 a b"
fi
