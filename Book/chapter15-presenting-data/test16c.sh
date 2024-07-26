#!/bin/bash
# testing input/output file descriptor
#
# cat testfile
# ./test16.sh
# cat testfile
#

exec 3<> testfile
echo "This is a test line" >&3
read line <&3
echo "Read: $line"
cat testfile
