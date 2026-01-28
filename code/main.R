#!/usr/bin/env Rscript
rlang::global_entrace()
library(argparse)
library(glue)
library(MOSuite)
library(readr)
library(stringr)
library(dplyr)

# set up results directory
results_dir <- file.path('..','results')
plots_dir <- file.path(results_dir, 'figures')
options(moo_plots_dir = plots_dir, moo_save_plots = TRUE)

# log installed packages & versions
pkg_versions <- tibble::as_tibble(installed.packages())
write_csv(pkg_versions, file.path(results_dir, 'r-packages.csv'))

# parse CLI arguments
parser <- ArgumentParser(description = "Create multi-omic dataset from files")

parser$add_argument("--delim", type="character", required=FALSE, default=",")
parser$add_argument("--regex_count", type="character", default="count.*.[ct]sv*")
parser$add_argument("--regex_sample", type="character", default="sample.*.[ct]sv*")

args <- parser$parse_args()

# find input files
regex_count = args$regex_count
regex_sample = args$regex_sample
data_dir <- "../data"
data_files <- list.files(file.path(data_dir), recursive = TRUE, full.names = TRUE)
message(glue("Data files found in {normalizePath(data_dir)}: {glue_collapse(data_files, sep = ', ')}"))
count_files <- Filter(\(x) str_detect(x, regex(regex_count, ignore_case = TRUE)), data_files)
sample_meta_files <- Filter(\(x) str_detect(x, regex(regex_sample, ignore_case = TRUE)), data_files)

# validate inputs
if (length(count_files) == 0) {
    stop(glue("No counts data file was found. Please place a csv or tsv file in data/ that matches this regex: {regex_count}"))
}
if (length(sample_meta_files) == 0) {
    stop(glue("No sample metadata file was found. Please place a csv or tsv file in data/ that matches this regex: {regex_sample}"))
}

count_filename <- count_files[1]
sample_metadata_filename <- sample_meta_files[1]
message(glue("Counts data file: {count_filename}"))
message(glue("Sample metadata file: {sample_metadata_filename}"))

# run MOSuite
moo <- create_multiOmicDataSet_from_files(
    sample_meta_filepath = sample_metadata_filename,
    feature_counts_filepath = count_filename,
    delim = args$delim
)
write_rds(moo, file.path(results_dir, 'moo', 'moo.rds'))