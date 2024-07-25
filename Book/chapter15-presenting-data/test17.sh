#!/bin/bash
# testing closing file descriptors
# Nao entendi muito bem como funcionou esse codigo...
#
# ./test17.sh
# cat test17file
#

exec 3> test17file
echo "This is a test line of data" >&3
exec 3>&-

cat test17file

exec 3> test17file
echo "This'll be bad" >&3