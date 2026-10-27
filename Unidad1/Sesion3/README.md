# Reproducible Bioinformatics — Session 1.3

## 1. Introduction

This session introduces basic programming and data analysis in R, including variables, numerical operations, loops, conditional statements, data import, exploratory data analysis, and scientific visualization.

The exercises also provide an introduction to genetic differentiation and isolation-by-resistance analyses. The main goals of this report are to document the implemented scripts, summarize the available results, and provide a reproducible record of the work completed.

## 2. Methods

The exercises were implemented in R and organized in separate scripts. Maize collection metadata were imported and explored using base R functions. Numerical examples were used to practice arithmetic, loops, and conditional logic. Population-genetic exercises involved Mantel and partial Mantel tests, as described in the available exercise notes and scripts.

Scripts are located in `scripts/`, explanatory notes for Exercise 6 are in `ejercicio6.md`, and exported figures are stored in `figures/`.

## 3. Results

### Exercises 1–3: Basic R programming

- [Exercise 1](scripts/ejercicio1.R): variables and logarithmic operations.
- [Exercise 2](scripts/ejercicio2.R): adding two to integers from 1 to 150.
- [Exercise 3](scripts/ejercicio3.R): counting numbers greater than 20.

These exercises provide practice with basic R syntax, numerical sequences, arithmetic operations, and logical conditions.

### Exercise 4: Importing maize metadata

[View script](scripts/ejercicio4.R). The script checks the input file, imports the maize metadata, and inspects the resulting table.

### Exercise 5: Loops and division

[View script](scripts/ejercicio5.R). A `for` loop divides 35 by the integers from 1 to 10. The modified loop uses `next` to skip even divisors and stores the odd-divisor results in a data frame.

The recorded results for odd divisors were 35, approximately 11.67, 7, 5, and approximately 3.89 for divisors 1, 3, 5, 7, and 9, respectively.

### Exercise 6: Isolation by resistance

[View exercise notes](ejercicio6.md). The notes describe an analysis involving 13 resistance scenarios. Effective-distance matrices are compared with transformed genetic differentiation values using `B.Fst / (1 - B.Fst)`, and Mantel correlation coefficients and p-values are collected.

The explanatory notes are present in this repository, but the executable script and the complete scenario-specific results have not been added here.

### Exercise 7: Function test

[View script](scripts/ejercicio7.R). The recorded output was 0.04.

### Exercise 8: Partial Mantel tests

[View script](scripts/ejercicio8.R). Partial Mantel tests were performed for the present and the LGM scenario labelled 1800 in the exercise data, controlling for flat geographic distance.

| Scenario | Mantel correlation (r) | p-value |
|---|---:|---:|
| Present | 0.05878 | 0.44722 |
| LGM (labelled 1800) | 0.2437 | 0.27083 |

Neither test was statistically significant at the 0.05 level.

### Exercise 9: Exploratory analysis of maize metadata

[View script](scripts/ejercicio9.R). The imported dataset contained 165 observations and 22 variables. The script examines variable names, data types, missing values, summary statistics, collection altitudes, and collection years.

#### Altitude distribution

![Histogram of maize collection altitudes](figures/ejercicio9_histograma_altitud.png)

#### Geographic distribution

![Geographic distribution of maize collections](figures/ejercicio9_distribucion_geografica.png)

The plots provide an initial view of the altitude distribution and the geographic coordinates of the collections.

## 4. Discussion

The programming exercises demonstrate basic numerical operations, loops, conditional logic, and data-frame construction. The metadata exercise illustrates how an imported biological dataset can be assessed before more advanced analyses.

For Exercise 8, both p-values exceed 0.05. Therefore, these tests do not provide statistically significant evidence of an association under the tested models. This does not establish that no relationship exists.

The Exercise 9 import generated character-encoding warnings. Although the dataset loaded and the figures were generated, text fields should be checked before further analyses. The current exploratory script documents the initial dataset structure and plots, but additional requested summaries or subsets should be added if they are part of the final assignment requirements.

## 5. Conclusions

This session provides practical experience with R programming, data import, exploratory analysis, and scientific plotting. It also introduces the interpretation of Mantel-based correlation results and the importance of distinguishing a non-significant result from evidence that an effect is absent.

The report and scripts provide a starting point for reproducible analysis. Further work should include resolving the metadata encoding warnings, documenting complete outputs, and adding the executable script and full results for Exercise 6. Exercise 10 was not completed and is not reported as a completed activity.

## Reproducibility

- R scripts: [`scripts/`](scripts/)
- Exercise 6 notes: [`ejercicio6.md`](ejercicio6.md)
- Figures: [`figures/`](figures/)

Some input data and helper scripts remain in the course-material directory and are not included in this repository. Consequently, paths may need to be adjusted to reproduce all analyses on another computer.
