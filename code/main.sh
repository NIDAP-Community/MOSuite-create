#!/usr/bin/env sh
set -euo pipefail

# set MOSuite options for plots
export MOO_SAVE_PLOTS=TRUE
export MOO_PLOTS_DIR=/results/plots
mkdir -p $MOO_PLOTS_DIR


#config options
FEATURE_COUNTS_FILEPATH="$1"
SAMPLE_META_FILEPATH="$2"


# resolve filenames under ../data/<subdir>/ ---
if [ "${FEATURE_COUNTS_FILEPATH##*/}" = "$FEATURE_COUNTS_FILEPATH" ]; then
  cand=$(find ../data -mindepth 2 -maxdepth 2 -type f -name "$FEATURE_COUNTS_FILEPATH" | head -n 1)
  #head -n 1 → take the first match if multiple exist.
  [ -n "$cand" ] && FEATURE_COUNTS_FILEPATH="$cand"
  echo FEATURE_COUNTS_FILEPATH="$cand"
fi
if [ "${SAMPLE_META_FILEPATH##*/}" = "$SAMPLE_META_FILEPATH" ]; then
  cand=$(find ../data -mindepth 2 -maxdepth 2 -type f -name "$SAMPLE_META_FILEPATH" | head -n 1)
  [ -n "$cand" ] && SAMPLE_META_FILEPATH="$cand"
  echo SAMPLE_META_FILEPATH="$cand"
fi


# Optional sanity checks (helpful debugging)
[ -f "$FEATURE_COUNTS_FILEPATH" ] || { echo "Missing: $FEATURE_COUNTS_FILEPATH"; exit 1; }
[ -f "$SAMPLE_META_FILEPATH" ] || { echo "Missing: $SAMPLE_META_FILEPATH"; exit 1; }


# Render args_create.json from template -> temp file
mkdir ../results/jsons/

export FEATURE_COUNTS_FILEPATH SAMPLE_META_FILEPATH
envsubst < json_args/args_create.json > ../results/jsons/args_create.rendered.json




mosuite create_multiOmicDataSet_from_files --json=../results/jsons/args_create.rendered.json
mosuite clean_raw_counts --json=json_args/args_clean.json
mosuite filter_counts --json=json_args/args_filter.json
mosuite normalize_counts --json=json_args/args_norm.json
mosuite diff_counts --json=json_args/args_diff.json
mosuite filter_diff --json=json_args/args_diff_filter.json


