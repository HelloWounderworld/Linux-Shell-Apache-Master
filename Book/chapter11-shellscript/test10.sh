#!/bin/bash
# Podemos usar o "bc" pelo terminal para realizar calculos de numeros quebrados
var1=$(echo "scale=4: 3.44 / 5" | bc)
echo The anser is $var1