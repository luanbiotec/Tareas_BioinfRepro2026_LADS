# ============================================================
# Exploracion inicial de datos de colectas de maiz
# Curso: Bioinformatica Reproducible
# Ejercicio 9
# ============================================================

# 1. Ruta al archivo de datos original
archivo_maiz <- "//wsl.localhost/Ubuntu/home/victoraliaga/LUAN/curso_bioinformatica/material_curso/Unidad1/Sesion3/PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt"

# 2. Comprobar que el archivo existe
if (!file.exists(archivo_maiz)) {
  stop("No se encuentra el archivo de datos. Revisa la ruta.")
}

# 3. Cargar los datos
meta_maiz <- read.delim(
  archivo_maiz,
  header = TRUE,
  stringsAsFactors = FALSE,
  check.names = TRUE
)

# 4. Explorar la estructura
dim(meta_maiz)
names(meta_maiz)
head(meta_maiz)
str(meta_maiz)

# 5. Revisar valores faltantes
colSums(is.na(meta_maiz))

# 6. Revisar tipos de variables
sapply(meta_maiz, class)

# 7. Resumen estadistico
summary(meta_maiz)

# 8. Explorar altitudes
summary(meta_maiz$Altitud)

# Colectas a 100 metros o menos
meta_maiz[
  !is.na(meta_maiz$Altitud) & meta_maiz$Altitud <= 100,
  c("Origen", "Raza", "Estado.1", "Altitud")
]

# 9. Revisar anos de colecta
sort(unique(meta_maiz$A.o._de_colecta))

# 10. Histograma de altitudes
hist(
  meta_maiz$Altitud,
  main = "Distribucion de altitud de las colectas",
  xlab = "Altitud (m)",
  ylab = "Numero de colectas",
  col = "lightblue",
  border = "white"
)

# 11. Distribucion geografica de las colectas
plot(
  meta_maiz$Longitud,
  meta_maiz$Latitud,
  main = "Distribucion geografica de las colectas de maiz",
  xlab = "Longitud",
  ylab = "Latitud",
  pch = 19,
  col = "darkgreen"
)