#!/bin/bash
# trying to access script parameters inside a function
#
# ./badtest1
#
# ./badtest1 10 15
#

function badfunc1 {
    echo $[ $1 * $2 ]
}

if [ $# -eq 2 ]
then
    # value=$(badfunc1 $1 $2) # this it works
    value=$(badfunc1)
    echo "The result is $value"
else
    echo "Usage: badtest1 a b"
fi
