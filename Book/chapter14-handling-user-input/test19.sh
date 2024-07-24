#!/bin/bash
# simple demonstration of the getopts command
#
# ./test19.sh -ab test1 -c
# ./test19.sh -b "test1 test2" -a
# ./test19.sh -abtest1
# ./test19.sh -d
# ./test19.sh -acde
# ./test19.sh -a -b valor1 -c valor2 arg1 arg2
#
echo
while getopts :ab:c opt
do
    case "$opt" in
        a) echo "Found the -a option" ;;
        b) echo "Found the -b option, with value $OPTARG" ;;
        c) echo "Found the -c option" ;;
        *) echo "Unknown option: $opt";;
    esac
done