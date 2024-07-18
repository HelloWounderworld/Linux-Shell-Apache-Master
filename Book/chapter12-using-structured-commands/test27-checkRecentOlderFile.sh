#!/bin/bash
# testing file dates
#
if [ test26.sh -nt test25.sh ]
then
    echo "The test26.sh file is newer than test25.sh"
else
    echo "The test25.sh file is newer than test26.sh"
fi
if [ test24.sh -ot test26.sh ]
then
    echo "The test24.sh file is older than the test26.sh file"
fi