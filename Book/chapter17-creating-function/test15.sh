#!/bin/bash
# using a function defined in the .bashrc file
# Por algum motivo mesmo definindo uma funcao dentro do .bashrc e quando chamo tal funcao via script nao esta funcionando...

value1=10
value2=5

result1=$(addem $value1 $value2)
result2=$(multem $value1 $value2)
result3=$(divem $value1 $value2)

echo "The result of adding them is: $result1"
echo "The result of multiplying them is: $result2"
echo "The result of dividing them is: $result3"
