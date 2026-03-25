# AI-Derived Blood Metabolite Panel for Early Lung Adenocarcinoma Diagnosis

This repository contains the analysis code and presentation from a Cancer AI Hackathon project investigating blood metabolomics as a tool for early lung adenocarcinoma diagnosis. Using machine learning on blood metabolomic data, the project identifies a concise panel of metabolites — centered on the phenylalanine–tyrosine axis — that can distinguish lung adenocarcinoma patients from healthy individuals without relying on clinical data.

**Authors:** Nathan Gilman, Qingchen (Jeremy) Yuan, Taylor Tillander, Forcha Peter Oben Akem

**Affiliations:** Herbert Wertheim College of Engineering & College of Medicine, University of Florida

---

## Repository Contents

| File | Description |
|---|---|
| `metabolomics.ipynb` | Main analysis notebook: preprocessing, modeling, feature selection, and pathway enrichment |
| `MetabolomicsPresentation.pptx` | Hackathon presentation summarizing methods, results, and conclusions |

---

## Data

The notebook expects two tab-delimited metabolomics data files placed in a `data/` directory:

```
data/
├── ST000368_1.txt                 # Phase 1 study data
├── ST000369.txt                   # Phase 2 study data
└── Fuzzy_Metabolite_Mapping.csv   # Metabolite name → KEGG ID mapping
```

The two-phase dataset covers approximately 300 patients (lung adenocarcinoma and healthy controls). The datasets originate from the [Metabolomics Workbench](https://www.metabolomicsworkbench.org/) studies ST000368 and ST000369.

---

## Analysis Overview

The notebook is organized into four major sections:

**1. Data Preparation**
Loads and merges the two-phase studies into a single unified dataset. Handles missing values and separates metabolite features from clinical variables (gender, smoking status, organ).

**2. Clinical vs. Metabolite-Only Model Comparison**
Trains 300 logistic regression models with and without clinical covariates to assess whether metabolites alone carry predictive power. A paired t-test (t = 2.588, p = 0.005) confirmed that including clinical data slightly harms model performance, demonstrating the standalone predictive value of the metabolomic signature.

**3. Top-K Metabolite Feature Selection**
Evaluates model performance as a function of the number of metabolites used (from the full panel down to the single most predictive). The analysis identifies a sweet spot at the top 25 metabolites, where median accuracy increases by ~10% over the full feature set.

| Model | Accuracy | Recall | F1 Score |
|---|---|---|---|
| Logistic Regression (all) | 61.4% | 65.5% | 65.0% |
| Logistic Regression (Top 25) | 71.3% | 74.6% | 74.3% |
| Linear SVM (all) | 67.2% | 68.9% | 69.1% |
| Linear SVM (Top 50) | 70.1% | 71.2% | 72.4% |

**4. Pathway Enrichment Analysis**
Maps the top 25 predictive metabolites to KEGG IDs and performs over-representation analysis via [MetaboAnalyst](https://www.metaboanalyst.ca/). The most significantly enriched pathway is **phenylalanine, tyrosine, and tryptophan biosynthesis** (FDR = 0.031), implicating disruption of phenylalanine hydroxylase (PAH) activity as a key metabolic signature of lung adenocarcinoma.

---

## Key Findings

- A panel of 25 blood metabolites achieves ~71% accuracy in distinguishing lung adenocarcinoma patients from healthy individuals.
- The phenylalanine–tyrosine metabolic axis is the most significantly disrupted pathway, consistent with PAH loss of function.
- Metabolite-only models outperform models that also incorporate clinical data, highlighting the potential of metabolomics for non-invasive early diagnosis.

---

## Requirements

Dependencies are managed via Conda using the provided `environment.yml` file. 

Install and activate the environment with:

```bash
conda env create -f environment.yml
conda activate UFHCC_AI_HACK
```

---

## Usage

```bash
jupyter notebook metabolomics.ipynb
```

Run all cells in order. Ensure the `data/` directory is populated before executing the Data Preparation section.

---

## Limitations

- Clinical metadata (age, cancer stage/grade, disease history, medication history) are unavailable in the source datasets.
- No prospective clinical validation has been conducted.
- Analysis is limited to metabolites present in both phases of the study, which may exclude informative compounds.
- Causal relationships between observed metabolite changes and lung adenocarcinoma cannot be established from this data alone.

---

## Acknowledgements

- AI Cancer Symposium & HCDS Seminar Organizers
- HiPerGator (University of Florida Research Computing) for computational resources
- Dr. Kiley Graim (University of Florida)
- Qingchen (Jeremy) Yuan is supported by the American Society of Hematology (AGHA) and the UF Health Cancer Center Predoctoral Fellowship (UFHCC)
