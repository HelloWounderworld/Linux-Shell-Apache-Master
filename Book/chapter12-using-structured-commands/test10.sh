#!/bin/bash
# Using numeric test evaluations
#
value1=10
value2=11
value3=12
value4=10
#
if [ $value1 -gt 5 ]
then
    echo "The test value $value1 is greater than 5"
fi
#
if [ $value1 -eq $value2 ]
then
    echo "The values are equal"
else
    echo "The values are different"
fi
#
if [ $value1 -ge $value4 ]
then
    echo "The $value1 is greater than $value4"
fi
#
if [ $value2 -le $value3 ]
then
    echo "The $value2 is less than or equal $value3"
fi
#
if [ $value4 -lt $value3 ]
then
    echo "The $value4 is less than $value3"
fi
#
if [ $value2 -ne $value3 ]
then
    echo "The $value2 is different of the $value3"
fi