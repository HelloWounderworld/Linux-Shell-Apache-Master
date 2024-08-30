#!/bin/bash
# simple script menu

function diskispace {
    clear
    df -k
}

function whoseon {
    clear
    who
}

function memusage {
    clear
    cat /proc/meminfo
}

function menu {
    clear
    echo
    echo -e "\t\t\tSys Admin Menu\n" # the -e option is used to help to use nonprintable items, such as the tab and newline characters
    echo -e "\t1. Display disk space"
    echo -e "\t2. Display logged on users"
    echo -e "\t3. Display memory usage"
    echo -e "\t0. Exit program\n\n"
    echo -en "\t\tEnter option: " #The -en option on the last line displays the line without adding the newline character at the end
    read -n 1 option # the -n defines the amount of characters that user is allowed to put without to need to press the Enter key
}

while true
do
    menu
    case $option in
    0)
        break ;;
    1)
        diskispace ;;
    2)
        whoseon ;;
    3)
        memusage ;;
    *)
        clear
        echo "Sorry, wrong selection" ;;
    esac
    echo -en "\n\n\t\t\tHit any key to continue"
    read -n 1 line
done
clear
