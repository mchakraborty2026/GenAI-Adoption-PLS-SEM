# Generative AI Adoption Among University Students: A PLS-SEM Study

**R | SmartPLS | PLS-SEM | TAM | UTAUT2 | Mediation | Predictive Analysis**

This project examines how **Perceived Ease of Use (PEOU)**, **Perceived Usefulness (PU)**, and **Social Influence (SI)** shape university students' **Behavioral Intention (BI)** to use generative AI for academic tasks.

The study was completed as a graduate Information Systems research project at the **University of Nevada, Reno**.

## Research model

![Proposed structural model](results/figures/proposed_structural_model.png)

The model includes four reflective constructs:

- **PEOU** — Perceived Ease of Use
- **PU** — Perceived Usefulness
- **SI** — Social Influence
- **BI** — Behavioral Intention

Age and prior GenAI experience were included as control variables. PU was tested as a mediator between PEOU and BI.

## Data

The survey was administered through **Qualtrics** using adapted measures from established technology-adoption research.

- Raw responses: **83**
- Final usable sample: **63**
- 7-point Likert scale
- Respondent-level survey data are **not publicly shared** for privacy reasons

## Analysis

PLS-SEM was used to evaluate:

- indicator reliability
- internal consistency reliability
- convergent validity
- discriminant validity
- structural collinearity
- path coefficients
- R² and f²
- mediation
- out-of-sample prediction using **PLSpredict**

## Key findings

| Relationship | β | p | Result |
|---|---:|---:|---|
| PEOU → PU | .506 | < .001 | Supported |
| PU → BI | .457 | .002 | Supported |
| PEOU → BI | .048 | .732 | Not supported |
| SI → BI | .077 | .562 | Not supported |

Additional findings:

- **PU R² = .257**
- **BI R² = .373**
- PEOU → PU effect size: **f² = .345**
- PU → BI effect size: **f² = .205**
- Significant indirect effect: **PEOU → PU → BI, β = .232, p = .010**
- The mediation pattern was **indirect-only mediation**
- PLS prediction errors were lower than the linear-model benchmark for all seven predicted indicators on both RMSE and MAE

## Final structural results

![Final structural results](results/figures/final_structural_results.png)

## Repository contents

```text
analysis/   R analysis workflow
data/       data-availability and privacy note
docs/       survey instrument and codebook
report/     final manuscript
results/    figures, publication tables, and result tables
```

## Files

- [Final manuscript](report/GenAI_Adoption_Manuscript.pdf)
- [Publication tables](results/GenAI_PUBLICATION_TABLES.xlsx)
- [R analysis](analysis/pls_sem_analysis.R)
- [Survey instrument](docs/survey_instrument.md)
- [Codebook](docs/codebook.md)

## Main takeaway

The results suggest that **ease of use matters mainly because it increases perceived usefulness**. Perceived usefulness was the strongest direct predictor of behavioral intention, while the direct effects of ease of use and social influence were not statistically significant.

---

**Author:** Mithoon Chakraborty  
**Program:** M.S. in Information Systems, University of Nevada, Reno
