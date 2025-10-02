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

set +a  



# Render args_create.json from template -> temp file
mkdir ../results/jsons/


envsubst < json_args/args_create.json > ../results/jsons/args_create.rendered.json
mosuite create_multiOmicDataSet_from_files --json=../results/jsons/args_create.rendered.json


