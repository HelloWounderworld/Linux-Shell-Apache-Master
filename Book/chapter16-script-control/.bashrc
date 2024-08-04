# .bashrc
# O trecho que vc poderia incluir no arquivo .bashrc para verificar como o shell ele e inicializado
# O trechoi abaixo te ajuda a se certificar o tipo de bash que vc esta inicializando.
# No caso, te fornece mais controle dos tipos de bash que vc esteja querendo manusear.
# Source global definitions
if [ -f /etc/bashrc ]; then
. /etc/bashrc
fi
# User specific aliases and functions
echo "I'm in a new shell!"