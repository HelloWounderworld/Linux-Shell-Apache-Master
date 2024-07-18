#!/bin/bash
# Check if either a directory or file exists
#
# item_name=$HOME
item_name="/home/teramatsu/sayHello.txt"
echo
echo "The item being checked: $item_name"
echo
#
if [ -e $item_name ]
then  #Item does exist
    echo "The item, $item_name, does exist."
    echo "But is it a file?"
    echo
    #
    if [ -f $item_name ]
    then #Item is a file
        echo "Yes, $item_name is a file."
        echo "But is it writable?"
        echo
        #
        if [ -w $item_name ]
        then #Item is writable
            echo "Writing current time to $item_name"
            date +%H%M >> $item_name
            echo "Hello, WounderWorld!" >> $item_name
            cat $item_name
        #
        else #Item is not writable
            echo "Unable to write to $item_name"
        fi
    #
    else #Item is not a file
        echo "No, $item_name is not a file."
    fi
    #
else   #Item does not exist
    echo "The item, $item_name, does not exist."
    echo "Nothing to update"
fi
#