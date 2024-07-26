#!/bin/bash
# storing STDOUT, then coming back to it
# Study more this concept to understand. is still confused at my mind
#
# ./test14.sh
# cat test14out
#
# Redirecionar: exec 1> testredi para enviar a saída padrão para testredi.
# Restaurar: exec 1>/dev/tty para enviar a saída padrão de volta para o terminal.
# Usar normalmente: A partir daí, a saída será exibida no terminal novamente.
#
# lsof -p $$ | grep '1w': Lista arquivos abertos para o shell atual e filtra para a saída padrão.
# ls -l /proc/self/fd/1: Mostra qual arquivo está sendo usado como saída padrão.
# cat <&1: Tenta ler da saída padrão.
#

exec 3>&1 # To dizendo o seguinte: Qualquer saida padrao devera ser considerado como algo alternativo
exec 1>test14out # To dizendo o seguinte: Em vez da saida ser exibido na tela, /dev/tty, apenas registre dentro desse arquivo, test14out

echo "This should store in the output file"
echo "along with this line."

exec 1>&3
exec 3>&-

echo "Now things should be back to normal"