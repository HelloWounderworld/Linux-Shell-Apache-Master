#!/bin/bash
# A more advanced version of the getopt command, called getopts (notice it is plural), is available. The getopts 
# command is covered later in this chapter. Because of their nearly identical spelling, it’s easy to get these two com
# mands confused. Be careful!
#
# Extract command line options & values with getopt
#
# ./test18.sh -ac
# ./test18.sh -a -b test1 -cd test2 test3 test4
# ./test18.sh -a -b test1 -cd "test2 test3" test4
#
set -- $(getopt -q ab:cd "$@")
#
echo
while [ -n "$1" ]
do
    case "$1" in
    -a) echo "Found the -a option" ;;
    -b) param="$2"
        echo "Found the -b option, with parameter value $param"
        shift ;;
    -c) echo "Found the -c option" ;;
    --) shift
        break ;;
    *) echo "$1 is not an option" ;;
    esac
    shift
done
#
count=1
for param in "$@"
do
    echo "Parameter #$count: $param"
    count=$[ $count + 1 ]
done
#