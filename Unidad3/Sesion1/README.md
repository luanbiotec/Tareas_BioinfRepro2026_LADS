# Unidad 3 – Sesión 1: Filtrado, alineamiento y evaluación de calidad de lecturas NGS

**Autor:** Luan Americo Da Silva  
**Programa:** Doctorado en Ciencias Biomédicas  
**Institución:** Universidad de Chile  
**Curso:** Bioinformática Reproducible  
**Fecha:** 19 de noviembre de 2026

## 1. Objetivo

Procesar las lecturas paired-end de la muestra S3 mediante eliminación de adaptadores y contaminantes, filtrado por calidad, alineamiento contra el genoma humano hg19 y evaluación del alineamiento utilizando Qualimap.

## 2. Herramientas

- **BBMap/BBDuk 38.90:** filtrado de adaptadores, PhiX y lecturas de baja calidad.
- **BWA 0.7.17:** alineamiento contra hg19.
- **Picard 2.25.2:** conversión, ordenamiento y asignación de grupos de lectura.
- **Samtools 1.12:** indexación del BAM.
- **Qualimap 2.2.1:** evaluación de cobertura, calidad de mapeo y otros parámetros.
- **Referencia:** hg19.
- **Regiones de interés:** `regiones_blanco.bed`.

## 3. Metodología

### 3.1. Filtrado de lecturas

Se utilizó BBDuk para eliminar adaptadores, contaminantes PhiX y bases de baja calidad, evitando interferencias durante el alineamiento.

**Adaptadores:**

```bash
bbduk.sh -Xmx2g threads=1 \
in1=~/181004_curso_calidad_datos_NGS/fastq_raw/S3_R1.fastq.gz \
in2=~/181004_curso_calidad_datos_NGS/fastq_raw/S3_R2.fastq.gz \
out1=S3_R1_filter1.fastq.gz \
out2=S3_R2_filter1.fastq.gz \
ref=~/resources/bbmap/adapters.fa tpe tbo
```

Se conservaron 63.682 lecturas (75,95 %).

**PhiX:**

```bash
bbduk.sh -Xmx2g threads=1 \
in1=S3_R1_filter1.fastq.gz \
in2=S3_R2_filter1.fastq.gz \
out1=S3_R1_filter2.fastq.gz \
out2=S3_R2_filter2.fastq.gz \
ref=~/resources/bbmap/phix174_ill.ref.fa.gz
```

Se eliminaron 8 lecturas y se conservaron 63.674 (99,99 % de la etapa anterior).

**Calidad:**

```bash
bbduk.sh -Xmx2g threads=1 \
in1=S3_R1_filter2.fastq.gz \
in2=S3_R2_filter2.fastq.gz \
out1=S3_R1_filter3.fastq.gz \
out2=S3_R2_filter3.fastq.gz \
qtrim=w trimq=20 minlength=30 minavgquality=20
```

Se aplicó trimming por calidad (Q20), longitud mínima de 30 nucleótidos y calidad promedio mínima de Q20. Se conservaron 62.270 lecturas (97,80 % de la entrada a esta etapa).

### 3.2. Alineamiento

BWA-MEM permitió alinear las lecturas filtradas contra hg19. Se utilizaron cuatro hilos (`-t 4`) y la opción `-M` para marcar alineamientos secundarios compatibles con herramientas posteriores.

```bash
bwa mem -t 4 -M /datos/reference/genomes/hg19_reference/hg19.fasta \
S3_R1_filter3.fastq.gz \
S3_R2_filter3.fastq.gz \
> S3.sam
```

### 3.3. Preparación del BAM

El SAM se convirtió a BAM, un formato binario más compacto y eficiente para almacenar alineamientos.

```bash
java -jar /opt/picard/picard-2.25.2/picard.jar SamFormatConverter -I S3.sam -O S3.bam
```

Luego, se ordenaron las lecturas por coordenadas genómicas para facilitar el acceso y análisis de regiones.

```bash
java -jar /opt/picard/picard-2.25.2/picard.jar SortSam I=S3.bam O=S3_sorted.bam SORT_ORDER=coordinate
```

Se agregaron grupos de lectura (Read Groups), metadatos que permiten identificar la biblioteca y mantener compatibilidad con herramientas de análisis posteriores.

```bash
java -jar /opt/picard/picard-2.25.2/picard.jar AddOrReplaceReadGroups \
-I S3_sorted.bam -O S3_sorted_RG.bam \
-ID sample -LB Paired-end -PL Illumina -PU Unknown -SM sample
```

Finalmente, se indexó el BAM mediante Samtools, generando un archivo BAI para acceder rápidamente a regiones específicas.

```bash
samtools index S3_sorted_RG.bam
```

### 3.4. Evaluación mediante Qualimap

Qualimap BAM QC evaluó cobertura, calidad de mapeo, tamaño de inserto, duplicación estimada y clipping, utilizando el archivo BED de regiones blanco.

```bash
JAVA_OPTS="-Xms32m -Xmx1200M" qualimap bamqc \
-bam S3_sorted_RG.bam \
-gff ~/181004_curso_calidad_datos_NGS/regiones_blanco.bed \
-outdir ./S3_sorted_RG
```

**Problema técnico:** la ejecución inicial falló por incompatibilidad con la opción Java `-XX:MaxPermSize=1024m` (`Unrecognized VM option`). Se resolvió sobrescribiendo temporalmente las opciones mediante `JAVA_OPTS` y ajustando la memoria máxima a 1200 MB (`-Xmx1200M`), sin modificar la instalación ni la configuración permanente del servidor. Qualimap finalizó correctamente y generó el reporte HTML y resultados de BAM QC.

## 4. Resultados

### 4.1. Alineamiento

Qualimap reportó 62.347 registros, de los cuales 62.323 fueron mapeados (99,96 %). La calidad de mapeo promedio (MAPQ) fue de 58,74, indicando elevada confianza global en la asignación.

### 4.2. Cobertura

La cobertura promedio fue de 101,28X, con una desviación estándar de 99,57X. El 91,44 % presentó cobertura ≥1X, el 72,49 % ≥30X y el 63,11 % ≥50X.

La desviación estándar cercana a la media indica una distribución heterogénea de la profundidad.

### 4.3. Tamaño de inserto

La mediana fue de 247 bp, la media de 251,66 bp y la desviación estándar de 40,04 bp. La distribución se concentró principalmente alrededor de estos valores, observándose una cola de fragmentos de mayor tamaño.

### 4.4. Errores y duplicación

La tasa general de error estimada fue de 0,27 %. Se identificaron 23.142 mismatches, 1.174 inserciones y 1.709 deleciones.

La duplicación estimada fue de 38,12 %, un parámetro relevante para evaluar la complejidad de la biblioteca y la redundancia de lecturas.

### 4.5. Soft-clipping

Se identificó en el SAM una lectura con CIGAR `2S100M`, correspondiente a dos nucleótidos soft-clipped y cien nucleótidos alineados. Los nucleótidos soft-clipped permanecen en la secuencia, pero no participan del alineamiento, pudiendo reflejar diferencias respecto de la referencia u otras características de los extremos.

## 5. Figuras

**Figura 1. Cobertura a lo largo de la referencia.** Distribución de profundidad de secuenciación que permite identificar regiones con cobertura heterogénea y sectores menos representados.

**Figura 2. Calidad de mapeo (MAPQ).** Distribución de los valores de calidad asignados a las lecturas alineadas, utilizada para evaluar la confianza del alineamiento.

**Figura 3. Tamaño de inserto.** Distribución de las distancias estimadas entre lecturas paired-end, que permite caracterizar los fragmentos secuenciados e identificar valores atípicos.

**Figura 4. Perfil de clipping.** Distribución de extremos de lectura no incorporados al alineamiento, permitiendo identificar posiciones donde se concentra el clipping.

## 6. Discusión

La elevada proporción de lecturas mapeadas (99,96 %) y el MAPQ promedio de 58,74 indican que la mayoría de las lecturas se asignaron con alta confianza a la referencia. Sin embargo, un alineamiento exitoso no garantiza una cobertura uniforme: la desviación estándar (99,57X) fue prácticamente equivalente a la media (101,28X), evidenciando una distribución heterogénea de profundidad. Esto implica que algunas regiones pueden estar altamente representadas mientras otras presentan cobertura insuficiente, lo que puede afectar la detección de variantes o la interpretación de resultados en regiones específicas.

La duplicación estimada de 38,12 % sugiere una proporción considerable de lecturas redundantes, que podría reducir la diversidad efectiva de la biblioteca y hacer que la profundidad aparente sobreestime la cantidad de información independiente disponible. No obstante, Qualimap reporta una estimación y no se realizó eliminación de duplicados, por lo que no puede afirmarse que todos correspondan a duplicados PCR.

El soft-clipping refleja la presencia de bases que no pudieron incorporarse al alineamiento. Puede originarse por diferencias respecto de la referencia, secuencias de baja calidad en los extremos, adaptadores residuales u otras características de las lecturas. La identificación de `2S100M` demuestra este fenómeno, aunque una lectura individual no permite determinar su causa.

La interpretación de la cobertura debe considerar el carácter dirigido del análisis y las regiones incluidas en el BED. La ausencia de cobertura en regiones fuera del objetivo de secuenciación no necesariamente representa un problema técnico. Por ello, es importante evaluar la cobertura de las regiones de interés y no extrapolar los resultados al genoma completo.

## 7. Conclusiones

El procesamiento de la muestra S3 permitió realizar el filtrado de lecturas, eliminar contaminantes, alinear contra hg19 y evaluar la calidad del archivo BAM mediante Qualimap.

Se obtuvo una elevada proporción de lecturas mapeadas (99,96 %) y una calidad promedio de mapeo alta (58,74). Sin embargo, la cobertura fue heterogénea, con una desviación estándar cercana a la media y un 72,49 % alcanzando al menos 30X.

En conjunto, los resultados indican un alineamiento global de alta calidad, aunque la profundidad no es uniforme y existe duplicación estimada considerable. Estos parámetros deben considerarse en análisis posteriores, priorizando la cobertura de las regiones de interés y la calidad de la información independiente disponible.

## 8. Anexos

Se incorpora el reporte completo de Qualimap, incluyendo el informe HTML, los resultados numéricos y las figuras complementarias.

