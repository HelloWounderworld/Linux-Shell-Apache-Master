#!/bin/bash
# testing file execution
#
if [ -x test23.sh ]
then
    echo "You can run the script: "
    ./test23.sh
else
    echo "Sorry, you are unable to execute the script"
fi
