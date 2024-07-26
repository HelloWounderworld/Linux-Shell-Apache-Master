#!/bin/bash
# testing STDERR messages
# Temporariamente, pois abaixo esta simulando erros que sera exibido em algum momento,
# mas que ele nao sera gravado em algum lugar.
# ./test8.sh
# ./test8.sh 2> test9
# cat test9
#
echo "This is an error" >&2
echo "This is normal output"
