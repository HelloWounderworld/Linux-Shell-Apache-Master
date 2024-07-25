#!/bin/bash
# testing STDERR messages
# ./test8.sh
# ./test8.sh 2> test9
# cat test9
#
echo "This is an error" >&2
echo "This is normal output"
