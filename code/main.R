#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(MOSuite)
library(readr)
library(dplyr)

# set up results directory
results_dir <- file.path('..','results')
plots_dir <- file.path(results_dir, 'figures')
options(moo_plots_dir = plots_dir, moo_save_plots = TRUE)
dir.create(plots_dir, recursive=TRUE)

# log installed packages & versions
message(R.version.string)
pkg_versions <- tibble::as_tibble(installed.packages())
write_csv(pkg_versions, file.path(results_dir, 'r-packages.csv'))
pkg_versions |> filter(Package == 'MOSuite') |> select(Package, LibPath, Version)

# parse CLI arguments
parser <- ArgumentParser(description = "Create multi-omic dataset from files")

parser$add_argument("--sample_metadata_filename", type="character", required=TRUE)
parser$add_argument("--raw_counts_filename", type="character", required=TRUE)
parser$add_argument("--delim", type="character", required=FALSE, default=",")

args <- parser$parse_args()

# validate inputs
for (f in c(args$sample_metadata_filename, args$raw_counts_filename)) {
    if (!file.exists(f)) {
        stop(glue("File not found: {f}"))
    } else {
        message(glue("Found file {f}"))
    }
}

# run MOSuite
moo <- create_multiOmicDataSet_from_files(
    sample_meta_filepath = args$sample_metadata_filename,
    feature_counts_filepath = args$raw_counts_filename,
    delim = args$delim
)
# moo <- create_multiOmicDataSet_from_dataframes(
#         sample_metadata = read_csv(args$sample_metadata_filename),
#         counts_dat = read_csv(args$raw_counts_filename)
# )
write_rds(moo, file.path(results_dir, 'moo.rds'))