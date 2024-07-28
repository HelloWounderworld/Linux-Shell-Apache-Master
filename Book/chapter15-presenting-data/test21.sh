#!/bin/bash
# using a temporary directory
#
# ./test21
# ls -al
# cd direotrio que foi criado
# ls -al
# cat temp.N5F3O6
# cat temp.SQslb7
#

# Caso vc queira criar esse diretorio temporario dentro do diretorio /tmp
# tempdir=$(mktemp -d -t dir.XXXXXX)
tempdir=$(mktemp -d dir.XXXXXX)
cd $tempdir
tempfile1=$(mktemp temp.XXXXXX)
tempfile2=$(mktemp temp.XXXXXX)
exec 7> $tempfile1
exec 8> $tempfile2

echo "Sending data to directory $tempdir"
echo "This is a test line of data for $tempfile1" >&7
echo "This is a test line of data for $tempfile2" >&8