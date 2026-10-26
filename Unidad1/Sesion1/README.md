# Reproducible Bioinformatics

## Academic Information

| Item | Details |
|---|---|
| Course | Reproducible Bioinformatics |
| Student | Luan Americo Da Silva |
| Postgraduate Program | Doctoral Program in Biomedical Sciences |
| Institution | University of Chile |
| Academic Year | 2026 |
| Instructor | Ricardo Verdugo S. |

## Repository Objective

This repository documents practical exercises developed during the Reproducible Bioinformatics course. It demonstrates Linux command-line operations, file management, Bash scripting, sequence retrieval, and reproducible analysis workflows.

## Exercise 1 — Linux Command Line and File Management

This exercise covers directory navigation, file creation and management, text searching, file inspection, compression, and extraction.

A list of maize sample identifiers was extracted from a `.fam` file and saved as `nombres_maiz.txt`.

## Exercise 2 — Bash Scripting

The script `crear_poblaciones.sh` creates four population directories (`PobA`, `PobB`, `PobC`, and `PobD`) and writes an `individuo.txt` file into each directory.

To run the script from the repository root:

```bash
bash crear_poblaciones.sh
```

## Exercise 3 — DNA Sequence Retrieval and Motif Counting

Five partial chloroplast `matK` coding sequences from *Pinus patula* were retrieved from NCBI and saved in FASTA format.

The script `ejercicio3/contar_tgca.sh` counts occurrences of the DNA motif `TGCA` in each sequence.

| Sequence accession | TGCA occurrences |
|---|---:|
| MH778523.1 | 1 |
| MH778522.1 | 1 |
| MH712868.1 | 1 |
| MH712867.1 | 1 |
| AY497284.1 | 4 |

The results are saved in `ejercicio3/resultados_tgca.txt`. These counts describe motif frequency only and do not establish a biological function for the motif.

## Repository Structure

```text
Sesion1/
├── README.md
├── crear_poblaciones.sh
├── nombres_maiz.txt
├── PobA/
│   └── individuo.txt
├── PobB/
│   └── individuo.txt
├── PobC/
│   └── individuo.txt
├── PobD/
│   └── individuo.txt
└── ejercicio3/
    ├── contar_tgca.sh
    ├── ids_limpios.txt
    ├── resultados_tgca.txt
    └── secuencias_matk.fasta
```

## Reproducibility

Run the following commands from the repository root:

```bash
bash crear_poblaciones.sh
bash ejercicio3/contar_tgca.sh
```

To save the motif-counting output:

```bash
bash ejercicio3/contar_tgca.sh > ejercicio3/resultados_tgca.txt
```

## Conclusions

These exercises introduce reproducible practices for organizing research files, automating repetitive tasks, retrieving biological sequences, and documenting simple computational analyses.

