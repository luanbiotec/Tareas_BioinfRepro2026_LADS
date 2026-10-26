#!/bin/bash

for poblacion in PobA PobB PobC PobD
do
    mkdir -p "$poblacion"
    echo "Este es un individuo de la población $poblacion" > "$poblacion/individuo.txt"
done


