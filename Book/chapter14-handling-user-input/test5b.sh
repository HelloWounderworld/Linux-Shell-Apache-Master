#!/bin/bash
# Using basename with the $0 parameter
# ./test5.sh
# bash /home/teramatsu/study/test5.sh
#
name=$(basename $0)
echo
echo The script name is: $name
#