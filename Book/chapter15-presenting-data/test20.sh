#!/bin/bash
# creating a temp file in /tmp
#
# O -t forca a criacao do arquivo no diretorio temporario, /tmp
# mktemp -t test.XXXXXX
# ls -al /tmp/test*
#

tempfile=$(mktemp -t tmp.XXXXXX)

echo "This is a test file." > $tempfile
echo "This is the second line of the test." >> $tempfile

echo "The temp file is located at: $tempfile"
cat $tempfile
rm -f $tempfile