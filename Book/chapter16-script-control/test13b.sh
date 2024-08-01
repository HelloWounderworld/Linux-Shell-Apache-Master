#!/bin/bash
# Test using at command
#
# at -M -f test13b.sh now
# cat test13b.out
# at -M -f test13b.sh teatime
# at -M -f test13b.sh tomorrow
# at -M -f test13b.sh 13:30
# at -M -f test13b.sh now
# atq
# atq
# atrm 18
# atq
#
echo "This script ran at $(date +%B%d,%T)" > test13b.out
echo >> test13b.out
sleep 5
echo "This is the script's end..." >> test13b.out
#
 