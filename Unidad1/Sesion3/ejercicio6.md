# Exercise 6: Analysis of `1.IBR_testing.r`

## 1. What do the two `for` loops do?

**First loop — Effective distance matrices**

The first loop iterates through 13 resistance scenarios: `present`, `ccsm`, `miroc`, `flat`, `1800`, `2000`, `2300`, `2500`, `2700`, `3000`, `3300`, `3500`, and `4000`.

For each scenario, it loads the corresponding resistance file using `read.effdist()`, calculates the mean effective distance for each population with `apply(eff.dist, 2, mean)`, and stores the distance matrix and mean distances in separate objects.

**Second loop — Isolation by Resistance (IBR) analysis**

The second loop analyzes the same 13 scenarios. It performs a Mantel test between each effective distance matrix and the transformed genetic differentiation matrix, `B.Fst / (1 - B.Fst)`. It then generates a distance plot, extracts the Mantel correlation coefficient and p-value, and stores the results in `IBRresults`.

## 2. Which R packages are required?

The script loads three packages:

- **`ade4`**: provides `mantel.rtest()` for Mantel tests.
- **`ggplot2`**: supports plotting functions, including those potentially used by `DistPlot.R`.
- **`sp`**: provides `spDists()` to calculate geographic distances.

The auxiliary scripts should also be checked for any additional package dependencies.

## 3. Which files are required?

### Auxiliary R scripts

- `read.fst_summary_fix.R`: reads and processes the genetic differentiation data.
- `read.effdist.R`: reads effective distance matrices.
- `DistPlot.R`: generates plots for the Mantel analysis.

### Input data files

- `../spatial/surveyed_mountains.tsv`: geographic information for sampled populations.
- `../genetic/BerSS.sumstats.tsv`: genetic summary statistics used to check population ordering.
- `../genetic/BerSS.fst_summary.tsv`: pairwise genetic differentiation data.
- `../spatial/resdist/Balpina_focalpoints.txt`: identifies focal populations.
- Thirteen resistance files named `Balpina_<scenario>_resistances.out`, one for each scenario listed above, located in `../spatial/resdist/`.

## 4. Execution requirements

The script uses relative paths, so it must be run from the `PracUni1Ses3/mantel/bin` directory unless the paths are modified. All input files and auxiliary scripts must be available at the expected locations.

## Conclusion

The script evaluates Isolation by Resistance by comparing genetic differentiation with effective distances derived from multiple resistance scenarios. The Mantel correlation coefficients and p-values are collected to compare the association between genetic and effective distances across scenarios.