# Ejercicio 5: divisiones con for loops

# Parte 1: dividir 35 entre los números del 1 al 10
for (i in 1:10) {
  print(35 / i)
}

# Parte 2: dividir solo entre números impares usando next
for (i in 1:10) {
  if (i %% 2 == 0) {
    next
  }
  print(35 / i)
}

# Parte 3: guardar los resultados en un data.frame
resultados <- data.frame(
  descripcion = character(0),
  resultado = numeric(0)
)

for (i in 1:10) {
  if (i %% 2 == 0) {
    next
  }
  resultados <- rbind(
    resultados,
    data.frame(
      descripcion = paste('resultado para', i),
      resultado = 35 / i
    )
  )
}

print(resultados)
