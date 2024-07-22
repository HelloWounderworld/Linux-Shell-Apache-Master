#!/bin/bash
# process new user accounts
# Por algum motivo em Linux Ubuntu24.04 nao funciona mas nas versoes anteriores funciona

input="users.csv"

# usertest="christine"
# nametest="Christine Blum"

# echo "adding: $usertest"
# echo "name: $nametest"

# useradd -c "$nametest" -m $usertest

if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root."
    exit 1
fi
echo
while IFS=',' read -r userid name
do
    userid=$(echo "$userid" | xargs)
    name=$(echo "$name" | xargs)

    echo "adding: $userid"
    echo "name: $name"

    useradd -c "$name" -m $userid
    echo
done < "$input"
