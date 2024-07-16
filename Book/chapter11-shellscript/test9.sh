#!/bin/bash
# bash support just integer numbers
# if you want to considerer float number you hava to use z shel (zsh)
var1=100
var2=45
var3=$[$var1 / $var2]
echo The final result is $var3
