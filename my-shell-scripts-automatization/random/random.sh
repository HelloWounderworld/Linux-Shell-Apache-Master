#!/bin/bash

# Diretório de origem
DIRETORIO_ORIGEM="caminho/do/diretorio/origem"
# Diretórios de destino
DIRETORIO_90="caminho/do/diretorio/destino_90"
DIRETORIO_10="caminho/do/diretorio/destino_10"

# Criar diretórios de destino se não existirem
mkdir -p "$DIRETORIO_90"
mkdir -p "$DIRETORIO_10"

# Contar o número total de arquivos
TOTAL_ARQUIVOS=$(find "$DIRETORIO_ORIGEM" -type f | wc -l)

# Calcular o número de arquivos para cada diretório
NUM_90=$((TOTAL_ARQUIVOS * 9 / 10))
NUM_10=$((TOTAL_ARQUIVOS - NUM_90))

# Selecionar arquivos aleatoriamente
ARQUIVOS=$(find "$DIRETORIO_ORIGEM" -type f | shuf)

# Mover 90% dos arquivos para o diretório 90%
echo "$ARQUIVOS" | head -n "$NUM_90" | while read -r ARQUIVO; do
    mv "$ARQUIVO" "$DIRETORIO_90"
done

# Mover 10% dos arquivos para o diretório 10%
echo "$ARQUIVOS" | tail -n "$NUM_10" | while read -r ARQUIVO; do
    mv "$ARQUIVO" "$DIRETORIO_10"
done

echo "Separação concluída: $NUM_90 arquivos em $DIRETORIO_90 e $NUM_10 arquivos em $DIRETORIO_10."