#!/bin/bash

directorio_script="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
archivo="$directorio_script/secuencias_matk.fasta"
secuencia=""
id=""

while IFS= read -r linea
do
    if [[ "$linea" == ">"* ]]; then
        if [[ -n "$id" ]]; then
            cantidad=$(printf '%s' "$secuencia" | grep -o 'TGCA' | wc -l)
            echo "$id: $cantidad"
        fi

        id="${linea#>}"
        id="${id%% *}"
        secuencia=""
    else
        secuencia+="$linea"
    fi
done < "$archivo"

if [[ -n "$id" ]]; then
    cantidad=$(printf '%s' "$secuencia" | grep -o 'TGCA' | wc -l)
    echo "$id: $cantidad"
fi

