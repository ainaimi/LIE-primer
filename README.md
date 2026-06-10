# A Law of Iterated Expectations Primer for Causal Inference

A tutorial paper explaining the law of iterated expectations and its role as the mathematical backbone of the g formula for causal effect identification and estimation.

## Authors

- **Ashley I. Naimi, PhD** (Corresponding Author)
  Department of Epidemiology, Emory University
  Email: ashley.naimi@emory.edu

- **Paul N Zivich III, PhD**
  Department of Epidemiology, UNC Chapel Hill

- **Stephen R Cole, PhD**
  Department of Epidemiology, UNC Chapel Hill

## About

This primer introduces the law of iterated expectations (also known as the law of total expectation or the tower rule), the integration notation used to express it, and its role as the mathematical backbone of causal effect identification via the g formula. The paper is aimed at applied researchers with limited statistics background.

Under the assumptions of counterfactual consistency, no interference, positivity, and conditional exchangeability, the law of iterated expectations can be rewritten as a causal standardization formula (the g formula) in two nonparametrically equivalent forms:

- **NICE** (Non-Iterative Conditional Expectation): a single weighted average of conditional outcome means
- **ICE** (Iterative Conditional Expectation): nested sequential expectations

Both forms are illustrated using three progressively complex numerical examples:

1. **Time-fixed, single binary confounder** — tamoxifen use and breast cancer recurrence (Sato & Matsuyama, 2003; n = 4,901)
2. **Time-fixed, mixed confounders** — quitting smoking and weight change from NHEFS (continuous, binary, and categorical confounders; n = 1,394)
3. **Time-varying, two timepoints** — simulated data with time-dependent confounding (adapted from Naimi et al., 2017)

## Manuscript Details

| Field               | Value                                               |
|---------------------|-----------------------------------------------------|
| Target Journal      | TBD                                                 |
| Text word count     | 3,699                                               |
| Abstract word count | 200                                                 |
| Figures             | 2                                                   |
| Tables              | 4                                                   |
| References          | 7                                                   |
| Running head        | Iterated Expectations: A Primer for Causal Inference |

## Key Topics

- Law of iterated expectations and integration notation (Riemann, Lebesgue, Riemann–Stieltjes)
- Causal identification assumptions: counterfactual consistency, no interference, positivity, conditional exchangeability
- The g formula as a causal reformulation of the law of iterated expectations
- NICE g computation (non-iterative form)
- ICE g computation (iterative/sequential form)
- Generalization to time-varying exposures and confounders
- Connection to doubly robust estimators (AIPW, TMLE)

**Keywords**: Causal Inference; Causal Identification; Iterated Expectation; G Formula; G Computation

## Project Structure

```
.
├── manuscript/           # Main manuscript files
│   ├── 2026_05_05-IdentificationEstimationMath.tex   # Main LaTeX document
│   ├── 2026_05_05-IdentificationEstimationMath.pdf   # Compiled PDF
│   ├── main_references.bib                            # Bibliography
│   └── epid.bst                                       # Bibliography style file
├── code/                # R analysis code
├── data/                # Datasets used in examples
├── figures/             # Figures and DAGs
├── _corpus/             # Reference papers and literature
├── _notes/              # Working notes and drafts
└── misc/                # Miscellaneous files
```

## Compiling the Document

The manuscript is written in LaTeX. To compile:

### Prerequisites

- LaTeX distribution (e.g., TeX Live, MiKTeX, or MacTeX)
- BibTeX for bibliography management

### Required LaTeX Packages

- `amsmath`, `amssymb`, `bm` — mathematical typesetting
- `algorithm`, `algpseudocode` — algorithm environments
- `natbib` — bibliography management
- `hyperref` — hyperlinks and cross-references
- `graphicx` — figure inclusion
- `booktabs`, `tabularx`, `longtable` — tables
- `lineno` — line numbers
- `caption`, `subcaption` — figure captions
- `mathpazo`, `mathabx` — fonts
- `syllogism`, `accents`, `cancel`, `relsize` — math utilities

### Compilation Steps

```bash
cd manuscript/
pdflatex 2026_05_05-IdentificationEstimationMath.tex
bibtex 2026_05_05-IdentificationEstimationMath
pdflatex 2026_05_05-IdentificationEstimationMath.tex
pdflatex 2026_05_05-IdentificationEstimationMath.tex
```

## Acknowledgements

The authors thank Dr. Edward Kennedy at CMU for sharing his causal inference course notes, on which some of the content is based.

## Funding

None.

## Conflicts of Interest

None declared.

## License

Copyright (c) 2026. All rights reserved.

---

**Last Updated**: May 2026
