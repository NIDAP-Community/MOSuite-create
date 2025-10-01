 # MOSuite Differential Expression Capsule — README

This capsule runs a multi‑step RNA-seq counts workflow using **MOSuite**. It auto‑discovers input files in `../data`, builds JSON argument files, and executes a fixed sequence of MOSuite subcommands to produce RDS objects and plots.

## What this capsule does

1. **Auto‑finds inputs** in `../data`:
   - Feature counts file whose name includes **`genes`** and ends with **`.txt.gz`**, **`.csv.gz`**, or **`.tsv.gz`**.
   - Sample metadata file whose name includes **`metadata`** and ends with **`.tsv.gz`**, **`.csv.gz`**, or **`.txt.gz`**.
   - If multiple matches exist, the *first* match is taken.
   - The run will fail if either file is not found; therefore **ensure both files are present in the data asset you attach** to this capsule. 
   
2. **Renders JSON configs** based on user-defined inputs provided via the capsule's app panel. For reproducibility, the dynamically generated JSONs are saved from each run to `../results/jsons/`.

3. **Runs MOSuite** steps in order:
   - `create_multiOmicDataSet_from_files`
   - `clean_raw_counts`
   - `filter_counts`
   - `normalize_counts`
   - `diff_counts`
   - `filter_diff`
4. **Saves outputs**:
   - Plots in `/results/plots/` (inside the capsule; also exported on completion)
   - RDS objects in `../results/RDS/`
   - JSON files in `../results/jsons/`



---


## How to run 

1. Attach your data asset to the capsule. 
2. Open the **App Panel** and define your parameters. There are no mandatory parameters, but default values are provided. 
3. Click **Reproducible Run**. Code Ocean executes `run.sh`, which delegates to `main.sh` with your arguments.

---

### File discovery rules
- **Counts:** first match of `*genes.txt.gz`, `*genes.csv.gz`, or `*genes.tsv.gz` anywhere under `../data`.
- **Metadata:** first match of `*metadata.tsv.gz`, `*metadata.csv.gz`, or `*metadata.txt.gz` anywhere under `../data`.

If no matching file is found, the script exits with an error.

---

## Outputs

- **Plots** in `/results/plots/`
- **Rendered JSONs** in `../results/jsons/` (for reproducibility and debugging)
- **RDS files** (intermediate & final) in `../results/RDS/`:
  - `moo.rds`, `moo.cleaned.rds`, `moo.cleaned.filtered.rds`, `moo.cleaned.filtered.normalized.rds`, `moo.cleaned.filtered.normalized.diff.rds`, `moo.cleaned.filtered.normalized.diff.filtered.rds`

---


## Parameters (passed from the Code Ocean App Panel)

 The script has been designed to take **22 parameters** as follows:

| #  | Name                         | Description |
|----|------------------------------|-------------|
| 1  | `GROUP_CONDITION_COLNAME`    | Column in metadata that defines groups/conditions. |
| 2  | `SAMPLE_ID`                  | Column in metadata with unique sample IDs (labels). |
| 3  | `MIN_NONZERO_COUNT_VAL`      | Minimum count value considered non‑zero. |
| 4  | `MIN_NOSAMPLE_COUNT_VAL_TOTAL` | Minimum number of samples with non‑zero counts (total). |
| 5  | `MIN_NOSAMPLE_COUNT_VAL_GROUP` | Minimum number of samples with non‑zero counts **per group**. |
| 6  | `COVARIATES_COLNAMES`        | Comma‑separated covariate column names (may be empty). |
| 7  | `CONTRAST_COLNAME`           | Column used to define contrasts. |
| 8  | `CONTRAST_TO_DO`             | One or more contrast expressions (format per MOSuite). |
| 9  | `SIG_THRESHOLD`              | Adjusted p‑value cutoff for DE filtering. |
| 10 | `FC_CUTOFF`                  | Effect size (e.g., logFC or FC) cutoff. |
| 11 | `CONTRAST_FILTER`            | Mode/filter string for contrasts (e.g., `any`, `all`, or specific). |
| 12 | `CONTRAST_NAMES_FILTER`      | Comma‑separated contrast names to include (if filtering). |
| 13 | `GROUPS_FILTER`              | Mode/filter string for groups. |
| 14 | `GROUPS_NAMES_FILTER`        | Comma‑separated group names to include (if filtering). |
| 15 | `DIFF_PLOT_TYPE`             | Plot type for DE summary (e.g., `bar`, `pie`). |
| 16 | `DIFF_LABEL_FONT_SIZE`       | Label font size used in plots. |
| 17 | `DIFF_LABEL_DIST`            | Label distance (plot parameter). |
| 18 | `DIFF_Y_EXPAN`               | Y‑axis expansion factor. |
| 19 | `DIFF_FILL_COLOURS`          | Comma‑separated color list for fills  |
| 20 | `DIFF_BAR_WIDTH`             | Bar width (plot parameter). |
| 21 | `DIFF_BAR_BORDER`            | Whether to draw bar borders (`TRUE`/`FALSE`). |
| 22 | `DIFF_PLOT_FONTSIZE`         | Overall plot title font size. |

> Tip: The script dynamically passes parameters supplied to template JSONs in the code folder, and saves the resulting "rendered" JSONs to the results folder. The script then executes its subcommands with the rendered JSONs.



---

## Troubleshooting

- **“No feature counts file found in ../data” / “No sample metadata file found in ../data”**  
  Ensure filenames include the expected keywords (`genes`, `metadata`) and extensions (`.txt.gz`, `.csv.gz`, `.tsv.gz`). Only the *first* match is used.
- **Script exits with “Missing: …”**  
  The resolved path doesn’t exist. Verify data is attached. 

---

## Reproducibility

The rendered JSONs in `../results/jsons/` capture the exact parameters used for each run. You can archive these alongside outputs for audit trails. Run parameters are also saved for each run in Code Ocean, and can be accessed under the "Parameter Values" button.

---

## License

This capsule’s shell scripts and configuration templates are provided as‑is for research workflows.
