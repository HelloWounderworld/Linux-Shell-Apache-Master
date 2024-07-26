#!/bin/bash
# testing lsof with file descriptors
#
# /usr/sbin/lsof
# /usr/bin/lsof
#
# /usr/sbin/lsof -a -p $$ -d 0,1,2
# /usr/bin/lsof -a -p $$ -d 0,1,2
#
# lsof -a -p $$ -d 0,1,2
#
# ./test18.sh
#

exec 3> test18file1
exec 6> test18file2
exec 7< testfile

# E uma dessas de baixo que funciona
# /usr/sbin/lsof -a -p $$ -d0,1,2,3,6,7
/usr/bin/lsof -a -p $$ -d0,1,2,3,6,7