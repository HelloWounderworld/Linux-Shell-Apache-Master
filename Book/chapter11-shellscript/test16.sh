#!/bin/bash
# testing the exit status
# 300 % 256 == 44
var1=10
var2=30
var3=$[$var1 * $var2]
echo The value is $var3
exit $var3