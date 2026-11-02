# Bioinformatics and Reproducible Research for Genetic Data Analysis

**Course:** Introduction to Bioinformatics and Reproducible Research for Genetic Data Analysis  
**Unit:** 2  
**Session:** 1 – Quality Control of NGS Reads  
**Assignment:** Unit 2 – Session 1  
**Student:** Luan Americo Da Silva  
**Program:** PhD Program in Biomedical Sciences, University of Chile  
**Date:** November 2, 2026

---

## Objective

To perform quality control of next-generation sequencing (NGS) reads using Unix tools and FastQC to analyze raw and filtered sequencing data. To compare the results obtained before and after filtering, identifying changes in read quality and sequencing characteristics.

---

## 1. Unix-Based Data Analysis

Unix commands were used to examine the FASTQ files corresponding to sample S3, both in their original and filtered versions. Additionally, the BED file containing the target regions was inspected.

### 1.1. Counting Reads in FASTQ Files

The combination of the `zcat` and `wc -l` commands was used to determine the number of reads contained in each compressed FASTQ file.

```bash
zcat file.fastq.gz | wc -l
```

The `zcat` command displays the contents of a compressed `.gz` file without requiring prior decompression. The `wc -l` command counts the number of lines in the output. Since each FASTQ read is represented by four lines, the total number of reads is obtained by dividing the resulting line count by four.

**Results**

| File | Lines | Number of reads |
|:---|---:|---:|
| `S3_R1.fastq.gz` | 167,700 | 41,925 |
| `S3_R2.fastq.gz` | 167,700 | 41,925 |
| `S3_R1_filter.fastq.gz` | 122,648 | 30,662 |
| `S3_R2_filter.fastq.gz` | 122,648 | 30,662 |

The original files contain 41,925 reads each, whereas the filtered files contain 30,662 reads each. This represents a reduction of 11,263 reads, equivalent to approximately 26.9% of the initial total. The read counts for R1 and R2 remain identical both before and after filtering.

### 1.2. Viewing the First 40 Lines

To inspect the structure of the FASTQ files, the first 40 lines of the original `S3_R1.fastq.gz` file were displayed using:

```bash
zcat S3_R1.fastq.gz | head -n 40
```

The `head -n 40` command displays the first 40 lines of the content, allowing the first ten reads to be examined.

### 1.3. Identification and Description of the Third Read

The third read corresponds to lines 9–12 of the FASTQ file. Its structure is shown below.

**Read identifier (ID)**

```text
@M03564:2:000000000-D29D3:1:1101:16551:1405 1:N:0:ATCACGAC+TAAGACAC
```

**Nucleotide sequence**

```text
AAGCTGACAGCTACTCCAACACCTTTGGGTGGTATGACTGGTTTCCACATGCAAACTGAAGATCGAACTATGAAAAGTGTTAATGACCAGCCATCTGGAAATCTTCCATTTTTAAAACCTGATGATATTCAATACTTTGATAAACTATTGGTAAGTGATACTAGCAGAAATAAACTATTAATTGTGTTCCAGAATTATAAATCATAACATTTCAACTTCCCTTAACAGCGAATTTCGACGATCGTTGCATT
```

**Separator**

```text
+
```

**Quality string**

```text
CCBCCFFFFFCFGGGGGGGGGGGHHHHHGEFGGHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHIHHHHHIHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHGHHHHHHHHHHHHHHHHGHHHHGHDFGGGGHHHFEGFGFGGFGGGGG0
```

The identifier contains information about the sequencing instrument, sequencing run, flow cell, lane, read position, and indexes used.

| Element | Information |
|:---|:---|
| Instrument | M03564 |
| Run number | 2 |
| Flow cell | 000000000-D29D3 |
| Lane | 1 |
| Tile | 1101 |
| X and Y coordinates | 16551:1405 |
| Read number | 1 |
| Filter status | N (the read passed the filter) |
| Control number | 0 |
| Indexes | ATCACGAC+TAAGACAC |

The second line contains the nucleotide sequence. The third line corresponds to the separator and may include the identifier again. The fourth line contains the characters encoding the quality scores of each base, following the Phred+33 system.

> **Note:** This inspection of the third read was performed using the original `S3_R1.fastq.gz` file.

### 1.4. Conversion of Phred Quality Scores

To interpret base quality, the first ten characters of the quality string from the third read were considered:

```text
CCBCCFFFFF
```

The files use Phred+33 encoding. Therefore, the Phred quality score is obtained by subtracting 33 from the ASCII value of each character:

$$
Q = \text{ASCII value} - 33
$$

**Results**

| Base | Character | ASCII value | Phred quality score (Q) |
|---:|:---:|---:|---:|
| 1 | C | 67 | 34 |
| 2 | C | 67 | 34 |
| 3 | B | 66 | 33 |
| 4 | C | 67 | 34 |
| 5 | C | 67 | 34 |
| 6 | F | 70 | 37 |
| 7 | F | 70 | 37 |
| 8 | F | 70 | 37 |
| 9 | F | 70 | 37 |
| 10 | F | 70 | 37 |

The first ten bases have quality scores ranging from Q33 to Q37, indicating high sequencing quality within this read segment.

### 1.5. Counting Target Regions in the BED File

The `wc -l` command was used to determine the number of lines in the `regiones_blanco.bed` file:

```bash
wc -l regiones_blanco.bed
```

The file contains **369 lines**, corresponding to 369 target region records.

To confirm the number of records while excluding potential empty lines or comments, the following command was also used:

```bash
awk 'NF > 0 && $1 !~ /^#/ {n++} END {print n}' regiones_blanco.bed
```

The result was also **369 target regions**.

### 1.6. Identification of Distinct Gene Symbols

Gene symbols are included in the fourth field of the BED file. In this field, the information is organized using `:` separators, while gene symbols may be separated by the `+` character.

The following command was used to extract the symbols:

```bash
awk -F '\t' '{split($4,a,":"); n=split(a[4],g,"+"); for(i=1;i<=n;i++) print g[i]}' regiones_blanco.bed | sort -u
```

The command performs the following operations:

- `awk -F '\t'`: interprets the file fields using tabs as separators.
- `split($4,a,":")`: splits the fourth field using `:` as the delimiter.
- `a[4]`: selects the section containing the gene symbols.
- `split(a[4],g,"+")`: separates the gene symbols using `+` as the delimiter.
- `print g[i]`: prints each identified symbol.
- `sort -u`: sorts the symbols and removes duplicates.

**List of distinct gene symbols**

```text
ABL1
BRAF
BRCA1
BRCA2
CALR
CBL
CEBPA
CRLF2
EZH2
FLT3
IKZF1
IL7
JAK2
JAK3
KIT
KRAS
MLL
MPL
P2RY8
PAX5
PDGFRA
PDGFRB
PTEN
RB1
SF3B1
TP53
WT1
```

### 1.7. Counting Distinct Genes

To determine the total number of distinct gene symbols, `wc -l` was added to the previous command:

```bash
awk -F '\t' '{split($4,a,":"); n=split(a[4],g,"+"); for(i=1;i<=n;i++) print g[i]}' regiones_blanco.bed | sort -u | wc -l
```

The result was **27 distinct genes**.

### 1.8. Summary of Results

The Unix-based analysis identified 41,925 reads in each original FASTQ file and 30,662 reads in each filtered file. Inspection of the third read in `S3_R1.fastq.gz` made it possible to identify the structure of a FASTQ record and convert its first ten quality scores using Phred+33 encoding.

Additionally, analysis of the BED file identified 369 target regions associated with 27 distinct gene symbols.

---

## 2. FastQC Analysis

FastQC was used to evaluate the quality of the original and filtered sequencing reads. The analysis included four FASTQ files corresponding to the paired-end sequencing data from sample S3.

**FastQC version:** 0.12.1

### 2.1. Input Files

The following files were analyzed:

| File | Description |
|:---|:---|
| `S3_R1.fastq.gz` | Original forward reads |
| `S3_R2.fastq.gz` | Original reverse reads |
| `S3_R1_filter.fastq.gz` | Filtered forward reads |
| `S3_R2_filter.fastq.gz` | Filtered reverse reads |

The original files were compared with their filtered counterparts to evaluate changes in sequencing quality and read characteristics.

### 2.2. FastQC Quality Control Modules

FastQC generates a set of quality control modules that provide complementary information about sequencing data.

The main modules considered in this analysis were:

- **Basic Statistics:** provides general information about the sequencing dataset, including the number of sequences, total bases, sequence length, and GC content.
- **Per Base Sequence Quality:** evaluates the distribution of quality scores at each position along the reads.
- **Per Tile Sequence Quality:** identifies potential variations in sequencing quality associated with different regions of the flow cell.
- **Per Sequence Quality Scores:** evaluates the distribution of average quality scores across individual sequences.
- **Per Base Sequence Content:** examines the relative proportions of A, T, G, and C at each position.
- **Per Sequence GC Content:** evaluates the distribution of GC content across individual sequences.
- **Per Base N Content:** measures the proportion of undetermined bases at each position.
- **Sequence Length Distribution:** describes the distribution of read lengths.
- **Sequence Duplication Levels:** evaluates the degree of sequence duplication.
- **Overrepresented Sequences:** identifies sequences that occur more frequently than expected.
- **Adapter Content:** detects the presence of sequencing adapter sequences.

FastQC assigns a Pass, Warning, or Fail status to each module according to its internal quality control thresholds. These classifications should be interpreted as indicators of potential issues rather than as definitive assessments of whether a sequencing dataset is suitable for downstream analysis.

---

## 3. FastQC Results

### 3.1. Basic Statistics

The Basic Statistics module provides an overview of the sequencing characteristics of each FASTQ file.

**Results**

| Metric | Original R1 | Filtered R1 | Original R2 | Filtered R2 |
|:---|---:|---:|---:|---:|
| Number of sequences | 41,925 | 30,662 | 41,925 | 30,662 |
| Total bases | 10.5 Mbp | 7.2 Mbp | 10.5 Mbp | 6.5 Mbp |
| Sequence length | 251 bp | 35–251 bp | 251 bp | 35–251 bp |
| GC content | 43% | 44% | 44% | 43% |

The number of sequences reported by FastQC is consistent with the read counts obtained using Unix commands. Both original files contain 41,925 reads, while the filtered files contain 30,662 reads.

The original reads have a fixed length of 251 bp. After filtering, the sequence length distribution ranges from 35 to 251 bp, indicating that reads with different lengths were retained.

The GC content ranges from 43% to 44% across the four datasets.

### 3.2. FastQC Module Summary

The quality control results for the four FASTQ files are summarized below.

| FastQC module | Original R1 | Filtered R1 | Original R2 | Filtered R2 |
|:---|:---:|:---:|:---:|:---:|
| Per base sequence quality | Pass | Pass | Warning | Pass |
| Per tile sequence quality | Pass | Pass | Pass | Pass |
| Per sequence quality scores | Pass | Pass | Pass | Pass |
| Per base sequence content | Warning | Pass | Fail | Pass |
| Per sequence GC content | Fail | Fail | Warning | Fail |
| Per base N content | Pass | Pass | Pass | Pass |
| Sequence length distribution | Pass | Warning | Pass | Warning |
| Sequence duplication levels | Fail | Fail | Fail | Fail |
| Overrepresented sequences | Warning | Warning | Warning | Warning |
| Adapter content | Fail | Pass | Fail | Pass |

The results show that filtering improved several quality control indicators, particularly adapter content and per-base sequence quality. However, some modules continued to show Warning or Fail classifications after filtering.

### 3.3. Per Base Sequence Quality

The Per Base Sequence Quality module evaluates the distribution of Phred quality scores at each position along the sequencing reads.

The original R1 file received a Pass classification, although a decline and greater variability in quality can be observed toward the 3' end. The filtered R1 file also received a Pass classification and showed high quality across most positions.

The original R2 file received a Warning classification, indicating a reduction in quality toward the 3' end. After filtering, the R2 file improved to a Pass classification.

These results suggest that filtering improved the per-base quality profile, particularly for the reverse reads.

### 3.4. Per Sequence Quality Scores

The Per Sequence Quality Scores module evaluates the distribution of average quality scores across individual reads.

All four datasets received a Pass classification. The average sequence quality scores were predominantly concentrated around Q37–Q38, indicating generally high average sequencing quality.

### 3.5. Per Base Sequence Content

The Per Base Sequence Content module evaluates the relative proportions of A, T, G, and C at each position along the reads.

The original R1 file received a Warning classification, while the original R2 file received a Fail classification. After filtering, both datasets received a Pass classification.

This change suggests that filtering improved the distribution of nucleotide composition across read positions.

### 3.6. Per Sequence GC Content

The Per Sequence GC Content module evaluates the distribution of GC content across individual reads and compares it with the expected distribution.

The original R1 file received a Fail classification, while the original R2 file received a Warning classification. After filtering, both R1 and R2 received a Fail classification.

Although the average GC content reported in Basic Statistics ranged from 43% to 44%, the Per Sequence GC Content module identified deviations in the distribution of GC content across individual sequences.

Therefore, the average GC percentage alone does not fully describe the GC content distribution of the dataset.

### 3.7. Sequence Duplication Levels

The Sequence Duplication Levels module evaluates the frequency of identical sequences within the dataset.

All four datasets received a Fail classification, indicating elevated sequence duplication according to FastQC thresholds.

For the original datasets, the percentage of sequences remaining after deduplication was:

- Original R1: 19.63%.
- Original R2: 20.75%.

These values describe the proportion of sequences remaining after deduplication in the FastQC assessment. They should not be interpreted directly as the percentage of duplicated reads.

The persistence of a Fail classification after filtering indicates that sequence duplication remains a characteristic requiring consideration in downstream analysis.

### 3.8. Overrepresented Sequences

All four datasets received a Warning classification in the Overrepresented Sequences module.

This module identifies sequences that occur more frequently than expected within the dataset. Overrepresented sequences may be associated with technical or biological factors, and their origin should be considered when interpreting sequencing quality.

### 3.9. Adapter Content

The Adapter Content module evaluates the presence of sequencing adapter sequences within the reads.

Both original files received a Fail classification, indicating detectable adapter content above the FastQC thresholds.

After filtering, both R1 and R2 received a Pass classification. This indicates that adapter content decreased sufficiently to fall below the module's warning and failure thresholds.

A Pass classification does not necessarily demonstrate the absolute absence of adapter sequences; rather, it indicates that the detected adapter content is below the thresholds used by FastQC.

---

## 4. Graphical Representation of FastQC Results

The following figures illustrate selected quality control metrics obtained from FastQC. Each figure compares the original and filtered sequencing datasets.

The panel organization is:

- **A:** Original R1.
- **B:** Filtered R1.
- **C:** Original R2.
- **D:** Filtered R2.

### 4.1. Sequence Length Distribution

This figure shows the distribution of read lengths before and after filtering. The original reads have a fixed length of 251 bp, whereas the filtered reads show a variable length distribution ranging from 35 to 251 bp.

The observed change in read length reflects the characteristics of the filtered datasets.

![Sequence Length Distribution](<resultados_fastqc/figuras informe U2_S1/Sequence Length Distribution.JPG>)

Figure 1. Distribution of read lengths before and after filtering. The length distribution of the sequences analyzed using FastQC is shown. (A) Original S3_R1 reads; (B) filtered S3_R1 reads; (C) original S3_R2 reads; and (D) filtered S3_R2 reads. The original reads have a length of 251 bp, whereas the filtered reads show variable lengths ranging from 35 to 251 bp.

### 4.2. Per Sequence GC Content

This figure shows the distribution of GC content across individual sequences in the four datasets.

The average GC content reported in Basic Statistics was 43% for original R1, 44% for filtered R1, 44% for original R2, and 43% for filtered R2.

The Per Sequence GC Content module evaluates the overall distribution rather than only the average GC percentage. This distinction helps explain why some datasets received a Fail classification despite having similar average GC values.

![Per Sequence GC Content](<resultados_fastqc/figuras informe U2_S1/Per Sequence GC Content.JPG>)

Figure 2. Distribution of per-sequence GC content before and after filtering. The distribution of guanine and cytosine (GC) content across the reads analyzed using FastQC is shown. (A) Original S3_R1 reads; (B) filtered S3_R1 reads; (C) original S3_R2 reads; and (D) filtered S3_R2 reads. The reported average GC content was 43%, 44%, 44%, and 43%, respectively. This distribution allows the base composition of the reads to be assessed and potential deviations from the expected GC profile to be identified.

### 4.3. Per Base Sequence Quality

This figure represents the distribution of quality scores at each position along the reads.

The original R2 dataset shows a decline in quality toward the 3' end, consistent with its Warning classification. Following filtering, the R2 dataset received a Pass classification.

The filtered R1 and R2 datasets show quality profiles that remain high across most read positions.

![Per Base Sequence Quality](<resultados_fastqc/figuras informe U2_S1/Per Base Sequence Quality.JPG>)

Figure 3. Per-base sequence quality across reads before and after filtering. The distributions of Phred quality scores at each read position, as reported by FastQC, are shown. (A) Original S3_R1 reads; (B) filtered S3_R1 reads; (C) original S3_R2 reads; and (D) filtered S3_R2 reads. The plots allow comparison of base quality across read positions and illustrate the changes associated with filtering, particularly the decrease in quality toward the 3′ end of the original reads.

### 4.4. Adapter Content

This figure compares adapter content in the original and filtered datasets.

Both original files received a Fail classification, whereas both filtered files received a Pass classification. This indicates a reduction in detectable adapter content following filtering.

![Adapter Content](<resultados_fastqc/figuras informe U2_S1/Adapter Content.JPG>)

Figure 4. Adapter content before and after filtering. The proportion of adapter sequences detected across the reads using FastQC is shown. (A) Original S3_R1 reads; (B) filtered S3_R1 reads; (C) original S3_R2 reads; and (D) filtered S3_R2 reads. The reports show a decrease in adapter content after filtering, with the original reads classified as Fail and the filtered reads classified as Pass.

---

## 5. Comparison Between Unix-Based Analysis and FastQC

The Unix-based analysis and FastQC provided complementary information about the sequencing datasets.

### 5.1. Read Counts

The number of reads obtained using Unix commands was consistent with the number of sequences reported by FastQC.

Both approaches identified 41,925 reads in each original FASTQ file and 30,662 reads in each filtered FASTQ file.

The reduction corresponds to 11,263 reads, or approximately 26.9% of the initial read count.

### 5.2. Read Length

The Unix-based inspection of the third read confirmed a sequence length of 251 nucleotides in the original R1 dataset.

However, the inspection of a single read does not establish the length distribution of the entire dataset. FastQC provided a broader assessment, showing that the original reads had a fixed length of 251 bp, while the filtered reads ranged from 35 to 251 bp.

### 5.3. Quality Scores

The Unix-based analysis allowed the quality scores of individual bases to be calculated using Phred+33 encoding.

The first ten characters of the third read in the original R1 file corresponded to quality scores ranging from Q33 to Q37.

FastQC complemented this analysis by evaluating quality scores across all reads and positions. The Per Sequence Quality Scores module showed predominantly high average quality scores, concentrated around Q37–Q38.

The Per Base Sequence Quality module also identified changes in quality along the read positions, particularly toward the 3' end of the original R2 dataset.

### 5.4. GC Content

The Unix-based analysis did not independently calculate GC content.

FastQC reported average GC contents of 43%, 44%, 44%, and 43% for original R1, filtered R1, original R2, and filtered R2, respectively.

The Per Sequence GC Content module also identified deviations in the distribution of GC content across individual reads, resulting in Warning or Fail classifications.

### 5.5. BED File Analysis

The Unix-based analysis of the BED file identified 369 target region records and 27 distinct gene symbols.

These results describe the characteristics of the target regions included in the analysis and are complementary to the quality control metrics obtained from FASTQ files.

### 5.6. Overall Comparison

Unix commands enabled direct inspection of the sequencing files, read counts, FASTQ structure, quality encoding, and target region information.

FastQC provided a broader evaluation of sequencing quality through multiple modules, allowing the identification of potential issues that cannot be assessed by inspecting only a small number of reads.

Together, these approaches provide complementary information for evaluating the quality and characteristics of raw and filtered sequencing data.

---

## 6. Discussion

The quality control analysis identified changes in sequencing characteristics following filtering of the original FASTQ files.

The number of reads decreased from 41,925 to 30,662 in both R1 and R2, corresponding to a reduction of approximately 26.9%. The identical read counts between forward and reverse files were maintained after filtering.

Several FastQC modules showed improvements following filtering. Adapter Content changed from Fail to Pass in both datasets. Per Base Sequence Quality improved from Warning to Pass in R2, while Per Base Sequence Content improved from Warning or Fail to Pass in both R1 and R2.

Despite these improvements, some quality control indicators remained unchanged or continued to show potential issues. Per Sequence GC Content received a Fail classification in both filtered datasets, and Sequence Duplication Levels received a Fail classification across all four files. Overrepresented Sequences also received a Warning classification in all datasets.

The change in sequence length distribution is another relevant characteristic. While the original reads had a fixed length of 251 bp, the filtered datasets contained reads ranging from 35 to 251 bp. This difference should be considered when selecting and interpreting downstream analytical procedures.

Overall, the results indicate that filtering improved specific aspects of sequencing quality, particularly adapter content and per-base quality profiles. However, filtering did not eliminate all potential quality-related concerns. Therefore, the different FastQC modules should be considered together rather than relying on a single quality indicator.

---

## 7. Conclusions

The quality control of sample S3 was performed using Unix commands and FastQC to characterize original and filtered paired-end sequencing reads.

The Unix-based analysis identified 41,925 reads in each original FASTQ file and 30,662 reads in each filtered file, corresponding to an approximate reduction of 26.9%. Inspection of the FASTQ structure also allowed the identification of sequencing metadata and the interpretation of base quality scores using Phred+33 encoding.

FastQC showed improvements in adapter content and per-base sequence quality following filtering. Nevertheless, some potential issues remained, particularly in the Per Sequence GC Content, Sequence Duplication Levels, and Overrepresented Sequences modules.

The analysis of the BED file identified 369 target region records associated with 27 distinct gene symbols.

In conclusion, Unix-based inspection and FastQC provided complementary information for evaluating the sequencing data. Although filtering improved several quality indicators, the remaining warnings and failures should be considered before proceeding with downstream analyses.

---

## 8. References

1. Andrews, S. (2010). *FastQC: A Quality Control Tool for High Throughput Sequence Data*. Babraham Bioinformatics.  
   https://www.bioinformatics.babraham.ac.uk/projects/fastqc/

2. u-genoma. *Bioinformatics and Reproducible Research for Genetic Data Analysis – Unit 2, Session 1: Quality Control of NGS Reads*. Course repository.  
   https://github.com/u-genoma/BioinfinvRepro/blob/master/Unidad2/Sesion1/Tutorial_Control_de_calidad_de_lecturas_NGS.md