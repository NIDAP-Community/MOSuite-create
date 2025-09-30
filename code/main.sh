#!/usr/bin/env sh
set -euo pipefail

# set MOSuite options for plots
export MOO_SAVE_PLOTS=TRUE
export MOO_PLOTS_DIR=/results/plots
mkdir -p $MOO_PLOTS_DIR


#config options
set -a #env autoexport
FEATURE_COUNTS_FILEPATH="$1"
SAMPLE_META_FILEPATH="$2"
GROUP_CONDITION_COLNAME="$3"
SAMPLE_ID="$4"

#count filtering
MIN_NONZERO_COUNT_VAL="$5"
MIN_NOSAMPLE_COUNT_VAL_TOTAL="$6"
MIN_NOSAMPLE_COUNT_VAL_GROUP="$7"

#diff expression
COVARIATES_COLNAMES="$8"
CONTRAST_COLNAME="$9"
CONTRAST_TO_DO="${10}"

#diff expression filtering
SIG_THRESHOLD=${11}
FC_CUTOFF=${12}
CONTRAST_FILTER="${13}"
CONTRAST_NAMES_FILTER="${14}"
GROUPS_FILTER="${15}"
GROUPS_NAMES_FILTER="${16}"

#plot options
DIFF_PLOT_TYPE="${17}"
DIFF_LABEL_FONT_SIZE=${18}
DIFF_LABEL_DIST=$(( ${19} ))
DIFF_Y_EXPAN=${20}
DIFF_FILL_COLOURS="${21}"
DIFF_BAR_WIDTH=${22}
DIFF_BAR_BORDER="${23}"
DIFF_PLOT_FONTSIZE=${24}
set +a  



echo DIFF_LABEL_DIST="${19}"


# resolve filenames under ../data/<subdir>/ ---
if [ "${FEATURE_COUNTS_FILEPATH##*/}" = "$FEATURE_COUNTS_FILEPATH" ]; then
  cand=$(find ../data -mindepth 1 -maxdepth 2 -type f -name "$FEATURE_COUNTS_FILEPATH" | head -n 1)
  #head -n 1 → take the first match if multiple exist.
  [ -n "$cand" ] && FEATURE_COUNTS_FILEPATH="$cand"
  echo FEATURE_COUNTS_FILEPATH="$cand"
fi
if [ "${SAMPLE_META_FILEPATH##*/}" = "$SAMPLE_META_FILEPATH" ]; then
  cand=$(find ../data -mindepth 1 -maxdepth 2 -type f -name "$SAMPLE_META_FILEPATH" | head -n 1)
  [ -n "$cand" ] && SAMPLE_META_FILEPATH="$cand"
  echo SAMPLE_META_FILEPATH="$cand"
fi


# Optional sanity checks (helpful debugging)
[ -f "$FEATURE_COUNTS_FILEPATH" ] || { echo "Missing: $FEATURE_COUNTS_FILEPATH"; exit 1; }
[ -f "$SAMPLE_META_FILEPATH" ] || { echo "Missing: $SAMPLE_META_FILEPATH"; exit 1; }




# Render args_create.json from template -> temp file
mkdir ../results/jsons/


envsubst < json_args/args_create.json > ../results/jsons/args_create.rendered.json
envsubst < json_args/args_clean.json > ../results/jsons/args_clean.rendered.json
envsubst < json_args/args_filter.json > ../results/jsons/args_filter.rendered.json
envsubst < json_args/args_norm.json > ../results/jsons/args_norm.rendered.json
envsubst < json_args/args_diff.json > ../results/jsons/args_diff.rendered.json
envsubst < json_args/args_diff_filter.json > ../results/jsons/args_diff_filter.rendered.json

mosuite create_multiOmicDataSet_from_files --json=../results/jsons/args_create.rendered.json
mosuite clean_raw_counts --json=../results/jsons/args_clean.rendered.json
mosuite filter_counts --json=../results/jsons/args_filter.rendered.json
mosuite normalize_counts --json=../results/jsons/args_norm.rendered.json
mosuite diff_counts --json=../results/jsons/args_diff.rendered.json
mosuite filter_diff --json=../results/jsons/args_diff_filter.rendered.json


