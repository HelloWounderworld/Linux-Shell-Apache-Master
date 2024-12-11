#!/bin/bash

# Diretório onde os arquivos ZIP estão localizados
DIRECTORY="/caminho/para/seu/diretorio"
OUTPUT_FILE="data.json"

# Verifica se o diretório existe
if [ ! -d "$DIRECTORY" ]; then
  echo "O diretório $DIRECTORY não existe."
  exit 1
fi

# Limpa o arquivo de saída se já existir
> "$OUTPUT_FILE"

# Lê todos os arquivos ZIP no diretório
for zip_file in "$DIRECTORY"/*.zip; do
  # Verifica se há arquivos ZIP no diretório
  if [ -e "$zip_file" ]; then
    echo "Processando arquivo ZIP: $zip_file"
    
    # Executa o comando Python e redireciona a saída para o arquivo
    python create_traindata_for_leo.py "$zip_file" >> "$OUTPUT_FILE"
    
    echo "Dados do arquivo $zip_file foram adicionados a $OUTPUT_FILE."
  else
    echo "Nenhum arquivo ZIP encontrado no diretório."
    break
  fi
done

echo "Processamento concluído. Os dados foram salvos em $OUTPUT_FILE."