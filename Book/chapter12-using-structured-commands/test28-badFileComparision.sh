#!/bin/bash
# testing file dates
# OBS: esses dois arquivos debaixo nem existem...
# Boas praticas: Garanta a existencia desses dois arquivos primeiro para realizar o comparativo de sua velhice (-nt or -ot)
if [ badfile1 -nt badfile2 ]
then
    echo "The badfile1 file is newer than badfile2"
else
    echo "The badfile2 file is newer than badfile1"
fi