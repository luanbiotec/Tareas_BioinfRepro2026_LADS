# Exercise 4: Import maize metadata from WSL

archivo <- "/home/victoraliaga/LUAN/curso_bioinformatica/material_curso/Unidad1/Sesion3/PracUni1Ses3/maices/meta/maizteocintle_SNP50k_meta_extended.txt"

# Check that the file exists
print(file.exists(archivo))

# Import the metadata table
meta_maiz <- read.delim(
  archivo,
  header = TRUE,
  stringsAsFactors = FALSE
)

# Inspect the imported data
print(class(meta_maiz))
print(dim(meta_maiz))
print(head(meta_maiz))
