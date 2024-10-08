#!/bin/bash
# creating and using a temp file
#
# Claro, fazer isso dentro do diretorio /tmp
# mktemp testing.XXXXXX
# mktemp testing.XXXXXX
# mktemp testing.XXXXXX
# ls -l testing*
#
# ./test19.sh
# ls -al test19*
#

tempfile=$(mktemp test19.XXXXXX)

exec 3>$tempfile

echo "This script writes to temp file $tempfile"

echo "This is the first line." >&3
echo "This is the second line." >&3
echo "This is the last line." >&3
exec 3>&-

echo "Done creating temp file. The contents are:"
cat $tempfile
rm -f $tempfile 2> /dev/null