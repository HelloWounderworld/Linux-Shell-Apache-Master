#!/bin/bash
# demonstrating a multi-position shift
# ./test14.sh 1 2 3 4 5
#
echo
echo "The original parameters: $*"
shift 2
echo "Here's the new first parameter: $1"
