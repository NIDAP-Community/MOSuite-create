#!/usr/bin/env sh
set -euo pipefail

# set MOSuite options for plots
export MOO_SAVE_PLOTS=TRUE
export MOO_PLOTS_DIR=/results/plots
mkdir -p $MOO_PLOTS_DIR

mosuite create_multiOmicDataSet_from_files --json=json_args/args_create.json
mosuite clean_raw_counts --json=json_args/args_clean.json
mosuite filter_counts --json=json_args/args_filter.json
mosuite normalize_counts --json=json_args/args_norm.json
mosuite diff_counts --json=json_args/args_diff.json
mosuite filter_diff --json=json_args/args_diff_filter.json


