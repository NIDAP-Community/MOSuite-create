setup_cli_workspace <- function(prefix = "mosuite_create_test_") {
  workspace <- tempfile(prefix)
  dir.create(workspace)

  code_dir <- file.path(workspace, "code")
  data_dir <- file.path(workspace, "data")
  results_dir <- file.path(workspace, "results")
  dir.create(code_dir, recursive = TRUE)
  dir.create(data_dir, recursive = TRUE)
  dir.create(file.path(results_dir, "figures"), recursive = TRUE)
  dir.create(file.path(results_dir, "moo"), recursive = TRUE)

  repo_root <- normalizePath(
    file.path(testthat::test_path(), "..", ".."),
    mustWork = TRUE
  )

  counts_fixture <- file.path(
    repo_root,
    "code",
    "MOSuite",
    "inst",
    "extdata",
    "nidap",
    "Raw_Counts.csv.gz"
  )
  sample_fixture <- file.path(
    repo_root,
    "code",
    "MOSuite",
    "inst",
    "extdata",
    "nidap",
    "Sample_Metadata_Bulk_RNA-seq_Training_Dataset_CCBR.csv.gz"
  )

  expect_true(
    file.exists(counts_fixture),
    info = paste("Counts fixture should exist at", counts_fixture)
  )
  expect_true(
    file.exists(sample_fixture),
    info = paste("Sample metadata fixture should exist at", sample_fixture)
  )

  # Names are chosen to satisfy default regexes in code/main.R.
  file.copy(
    counts_fixture,
    file.path(data_dir, "counts.csv.gz"),
    overwrite = TRUE
  )
  file.copy(
    sample_fixture,
    file.path(data_dir, "sample_metadata.csv.gz"),
    overwrite = TRUE
  )

  file.copy(
    file.path(repo_root, "code", "main.R"),
    file.path(code_dir, "main.R"),
    overwrite = TRUE
  )

  # Keep main.R behavior the same while pointing to this checkout's MOSuite package.
  main_copy <- file.path(code_dir, "main.R")
  main_lines <- readLines(main_copy)
  main_lines <- gsub(
    "devtools::load_all('/code/MOSuite')",
    sprintf(
      "devtools::load_all('%s')",
      file.path(repo_root, "code", "MOSuite")
    ),
    main_lines,
    fixed = TRUE
  )
  writeLines(main_lines, main_copy)

  list(
    workspace = workspace,
    code_dir = code_dir,
    results_dir = results_dir,
    repo_root = repo_root
  )
}

expect_outputs_created <- function(results_dir) {
  moo_path <- file.path(results_dir, "moo", "moo-raw.rds")

  expect_true(file.exists(moo_path), info = "Raw MOO output should be created")
  expect_true(
    file.info(moo_path)$size > 0,
    info = "Raw MOO output should be non-empty"
  )

  moo <- readr::read_rds(moo_path)
  expect_true(
    S7::S7_inherits(moo, MOSuite::multiOmicDataSet),
    info = "Output should be an S7 multiOmicDataSet object"
  )
}

common_cli_args <- c(
  "--delim=,"
)
