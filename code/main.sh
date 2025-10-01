#!/usr/bin/env sh
set -euo pipefail
set -a #env autoexport

# set MOSuite options for plots
export MOO_SAVE_PLOTS=TRUE
export MOO_PLOTS_DIR=/results/plots
mkdir -p $MOO_PLOTS_DIR
mkdir -p ../results/RDS

#find data

FEATURE_COUNTS_FILEPATH=$(find -L ../data \
  \( -name "*genes.txt.gz" -o -name "*genes.csv.gz" -o -name "*genes.tsv.gz" \) | head -n 1)


SAMPLE_META_FILEPATH=$(find -L ../data \
  \( -name "*metadata.tsv.gz" -o -name "*metadata.csv.gz" -o -name "*metadata.txt.gz" \)  | head -n 1)



if [ -n "$FEATURE_COUNTS_FILEPATH" ]; then
  echo "Found feature counts file: $FEATURE_COUNTS_FILEPATH"
else
  echo "No feature counts file found in ../data"
fi

if [ -n "$SAMPLE_META_FILEPATH" ]; then
  echo "Found sample metadata file: $SAMPLE_META_FILEPATH"
else
  echo "No sample metadata file found in ../data"
fi

#config options

GROUP_CONDITION_COLNAME="$1"
SAMPLE_ID="$2"

# count filtering
MIN_NONZERO_COUNT_VAL="$3"
MIN_NOSAMPLE_COUNT_VAL_TOTAL="$4"
MIN_NOSAMPLE_COUNT_VAL_GROUP="$5"

# diff expression
COVARIATES_COLNAMES="$6"
CONTRAST_COLNAME="$7"
CONTRAST_TO_DO="$8"

# diff expression filtering
SIG_THRESHOLD="$9"
FC_CUTOFF="${10}"
CONTRAST_FILTER="${11}"
CONTRAST_NAMES_FILTER="${12}"
GROUPS_FILTER="${13}"
GROUPS_NAMES_FILTER="${14}"

# plot options
DIFF_PLOT_TYPE="${15}"
DIFF_LABEL_FONT_SIZE="${16}"
DIFF_LABEL_DIST="${17}"
DIFF_Y_EXPAN="${18}"
DIFF_FILL_COLOURS="${19}"
DIFF_BAR_WIDTH="${20}"
DIFF_BAR_BORDER="${21}"
DIFF_PLOT_FONTSIZE="${22}"

set +a  



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


