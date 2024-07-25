#!/bin/bash
# storing STDOUT, then coming back to it
# Study more this concept to understand. is still confused at my mind
#
# ./test14.sh
# cat test14out
#

exec 3>&1
exec 1>test14out

echo "This should store in the output file"
echo "along with this line."

exec 1>&3

echo "Now things should be back to normal"