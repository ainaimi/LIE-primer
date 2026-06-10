# A Law of Iterated Expectation Primer for Causal Inference

A tutorial paper explaining the law of iterated expectation and its role as the mathematical backbone of the g formula for causal effect identification and estimation.

## Authors

- **Ashley I. Naimi, PhD** (Corresponding Author)
Department of Epidemiology,
Department of Data and Decision Science,
Emory University
Email: ashley.naimi@emory.edu

- **Razieh Nabi, PhD**
Department of Biostatistics,
Department of Bioinformatics,
Emory University

- **Lindsay Collin, PhD**
Department of Epidemiology,
Emory University

- **Paul N Zivich III, PhD**
Department of Epidemiology,
UNC Chapel Hill

- **Stephen R Cole, PhD**
Department of Epidemiology,
UNC Chapel Hill

## About

This primer introduces the law of iterated expectation (also known as the law of total expectation or the tower rule), the integration notation used to express it, and its role as the mathematical backbone of causal effect identification via the g formula. The paper is aimed at applied researchers with limited statistics background.

Under the assumptions of causal consistency, positivity, and conditional exchangeability, the law of iterated expectation can be rewritten as a causal standardization formula (the g formula) in two nonparametrically equivalent forms:

- **NICE** (Non-Iterative Conditional Expectation): a single weighted average of conditional outcome means
- **ICE** (Iterative Conditional Expectation): nested sequential expectations

Both forms are illustrated using three progressively complex numerical examples:

1. **Time-fixed, single binary confounder** — tamoxifen use and breast cancer recurrence (Sato & Matsuyama, 2003; n = 4,901)
2. **Time-fixed, mixed confounders** — quitting smoking and weight change from NHEFS (continuous, binary, and categorical confounders; n = 1,394)
3. **Time-varying, two timepoints** — simulated data with time-dependent confounding (adapted from Naimi et al., 2017)

## Project Structure

```
.
├── code/
│   ├── gFormula_tamoxifen.R        # Example 1: NICE and ICE, tamoxifen data
│   ├── NICE_gFormula.R             # Example 2: NICE g-formula, NHEFS data
│   ├── ICE_gFormula.R              # Example 2: ICE g-formula, NHEFS data
│   ├── data_gen.R                  # Example 3: simulate time-varying data
│   ├── NICE_gFormula_timevarying.R # Example 3: NICE g-formula, time-varying
│   └── ICE_gFormula_timevarying.R  # Example 3: ICE g-formula, time-varying
├── data/
│   ├── nhefs.csv                   # NHEFS data (Example 2)
│   └── NHEFS_Codebook.xls          # NHEFS variable descriptions
└── figures/
    ├── simple_dag_a.tex            # DAG source for Figure 1
    └── simple_dag_b.tex            # DAG source for Figure 2
```

## Running the Code

### Prerequisites

Install R (≥ 4.0) and the `pacman` package, which handles all other dependencies:

```r
install.packages("pacman")
```

All scripts use `pacman::p_load()` to install and load required packages automatically on first run. Key packages used across scripts: `tidyverse`, `here`, `xtable`, `lmtest`, `sandwich`, `broom`, `skimr`, `rio`, `GGally`.

Scripts use the [`here`](https://here.r-lib.org/) package for file paths. Open the project in RStudio (or set your working directory to the repo root) before running any script.

---

### Example 1 — Tamoxifen (time-fixed, binary confounder)

Reproduces the NICE and ICE calculations from Section 3 of the paper using tabulated data from Sato & Matsuyama (2003). No external data file required.

```r
source("code/gFormula_tamoxifen.R")
```

Expected output: `NICE ATE = -0.033`, `ICE ATE = -0.033`

---

### Example 2 — NHEFS (time-fixed, mixed confounders)

Estimates the effect of quitting smoking on weight change using NICE and ICE g-computation with continuous, binary, and categorical confounders. Reads `data/nhefs.csv`.

```r
source("code/NICE_gFormula.R")
source("code/ICE_gFormula.R")
```

Expected output: `ATE ≈ 3.1 kg` from both scripts.

---

### Example 3 — Time-varying confounding (two timepoints)

**Step 1 — Generate the data.** The simulated dataset (`time_varying_data.csv`, ~27 MB) is not stored in this repository. Run `data_gen.R` once to create it:

```r
source("code/data_gen.R")
```

This writes `data/time_varying_data.csv` (N = 1,000,000 rows) and prints the ICE estimate as a check.

**Step 2 — Run NICE and ICE estimators.**

```r
source("code/NICE_gFormula_timevarying.R")
source("code/ICE_gFormula_timevarying.R")
```

Expected output: `ATE ≈ 3.29` from both scripts.

> **Note on NICE vs ICE in time-varying settings:** NICE requires an explicit model for the time-varying confounder Z1; misspecification of that model introduces bias. ICE does not require this model, making it robust to Z1-model misspecification at the cost of requiring a correctly specified outcome model.

---

## Key Topics

- Law of iterated expectation and integration notation (Riemann, Lebesgue, Riemann–Stieltjes)
- Causal identification assumptions: counterfactual consistency, no interference, positivity, conditional exchangeability
- The g formula as a causal reformulation of the law of iterated expectation
- NICE g computation (non-iterative form)
- ICE g computation (iterative/sequential form)
- Generalization to time-varying exposures and confounders
- Connection to doubly robust estimators (AIPW, TMLE)

**Keywords**: Causal Inference; Causal Identification; Iterated Expectation; G Formula; G Computation

## Acknowledgements

The authors thank Dr. Edward Kennedy at CMU for sharing his causal inference course notes, on which some of the content is based.

## Funding

None.

## Conflicts of Interest

None declared.

## License

Copyright (c) 2026. All rights reserved.
