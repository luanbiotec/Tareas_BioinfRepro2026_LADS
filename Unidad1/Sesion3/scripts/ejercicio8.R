# Ejercicio 8: Partial Mantel test
# Elefante blanco

# Cargar paquete y funciones auxiliares
library(vegan)
ruta_bin <- '../../bin'
source(file.path(ruta_bin, 'read.fst_summary_fix.R'))
source(file.path(ruta_bin, 'read.effdist.R'))

# Definir poblaciones y rutas
popNames <- c('Aj', 'Iz', 'Ma', 'Pe', 'Tl', 'To')
points.info <- read.delim('../surveyed_mountains.tsv')
focpoints <- read.delim('Balpina_focalpoints.txt', header = FALSE)
focpoints.info <- points.info[points.info$ID %in% focpoints[, 1], ]
popNamesFP <- as.vector(focpoints.info$Key)

# Cargar matriz genética y linealizar Fst
B.Fst <- read.fst_summary_fix(
  file = '../../genetic/BerSS.fst_summary.tsv',
  popNames = popNames
)
B.FstLin <- B.Fst / (1 - B.Fst)

# Cargar matrices de resistencia
B.present <- read.effdist(
  file = 'Balpina_present_resistances.out',
  npop = 6, popNames = popNamesFP, des.order = popNames
)
B.1800 <- read.effdist(
  file = 'Balpina_1800_resistances.out',
  npop = 6, popNames = popNamesFP, des.order = popNames
)
B.flat <- read.effdist(
  file = 'Balpina_flat_resistances.out',
  npop = 6, popNames = popNamesFP, des.order = popNames
)

# Partial Mantel: presente, controlando por flat
resultado_present <- vegan::mantel.partial(
  as.dist(B.present), as.dist(B.FstLin), as.dist(B.flat),
  method = 'pearson', permutations = 9999
)

# Partial Mantel: LGM (1800), controlando por flat
resultado_1800 <- vegan::mantel.partial(
  as.dist(B.1800), as.dist(B.FstLin), as.dist(B.flat),
  method = 'pearson', permutations = 9999
)

# Mostrar resultados
print(resultado_present)
print(resultado_1800)
