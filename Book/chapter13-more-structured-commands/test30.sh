#!/bin/bash
# process new user accounts

input="users.csv"

if [ "$(id -u)" -ne 0 ]; then
    echo "Este script deve ser executado como root."
    exit 1
fi

while IFS=',' read -r userid name
do
    echo "adding $userid"
    echo "name: $name"
    useradd -c "$name" -m $userid
done < "$input"