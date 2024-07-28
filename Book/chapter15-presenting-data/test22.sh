#!/bin/bash
# using the tee command for logging
#
# date | tee testfile
# cat testfile
#
# who | tee testfile
# cat testfile
#
# to append
# date | tee -a testfile
# cat testfile
#
# ./test22.sh
# cat test22file
#

tempfile=test22file

echo "This is the start of the test" | tee $tempfile
echo "This is the second line of the test" | tee -a $tempfile
echo "This is the end of the test" | tee -a $tempfile