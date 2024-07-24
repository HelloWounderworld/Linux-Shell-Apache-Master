#!/bin/bash
# getting just one character of input - justo put 1 with -n to indicate it
#
read -n1 -p "Do you want to continue [Y/N]? " answer
case $answer in
Y | y) echo
       echo "fine, continue on...";;
N | n) echo
       echo "OK, goodbye"
       exit ;;
esac
echo "This is the end of the script"