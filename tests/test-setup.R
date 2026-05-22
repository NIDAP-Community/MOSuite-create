#!/usr/bin/env Rscript

cat("Testing basic test setup...\n")

cwd <- getwd()
cat("Current directory:", cwd, "\n")

repo_root_script <- normalizePath(dirname(cwd))
cat("Calculated repo_root:", repo_root_script, "\n")

count_fixture <- file.path(
  repo_root_script,
  "..",
  "code",
  "MOSuite",
  "inst",
  "extdata",
  "nidap",
  "Raw_Counts.csv.gz"
)
sample_fixture <- file.path(
  repo_root_script,
  "..",
  "code",
  "MOSuite",
  "inst",
  "extdata",
  "nidap",
  "Sample_Metadata_Bulk_RNA-seq_Training_Dataset_CCBR.csv.gz"
)
cat("\nLooking for counts fixture at:", count_fixture, "\n")
cat("Counts fixture exists:", file.exists(count_fixture), "\n")
cat("Looking for sample fixture at:", sample_fixture, "\n")
cat("Sample fixture exists:", file.exists(sample_fixture), "\n")

code_main <- file.path(repo_root_script, "..", "code", "main.R")
code_run <- file.path(repo_root_script, "..", "code", "run")
cat("code/main.R exists:", file.exists(code_main), "\n")
cat("code/run exists:", file.exists(code_run), "\n")
