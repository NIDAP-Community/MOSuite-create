counts_url <- 'https://raw.githubusercontent.com/CCBR/MOSuite/main/inst/extdata/nidap/Raw_Counts.csv.gz'
sample_meta_url <- 'https://raw.githubusercontent.com/CCBR/MOSuite/main/inst/extdata/nidap/Sample_Metadata_Bulk_RNA-seq_Training_Dataset_CCBR.csv.gz'

test_that("code/run executes successfully with default CLI arguments", {
  # Create temporary workspace
  workspace <- tempfile("mosuite_create_test_")
  dir.create(workspace)
  on.exit(unlink(workspace, recursive = TRUE), add = TRUE)

  # Set up directory structure
  code_dir <- file.path(workspace, "code")
  data_dir <- file.path(workspace, "data")
  results_dir <- file.path(code_dir, "..", "results")
  dir.create(code_dir)
  dir.create(data_dir)
  dir.create(results_dir)
  dir.create(file.path(results_dir, "figures"), recursive = TRUE)
  dir.create(file.path(results_dir, "moo"), recursive = TRUE)

  # Download test data
  counts_file <- file.path(data_dir, "Raw_Counts.csv.gz")
  sample_meta_file <- file.path(data_dir, "Sample_Metadata.csv.gz")

  tryCatch({
    download.file(counts_url, counts_file, quiet = TRUE, mode = "wb", timeout = 30)
    download.file(sample_meta_url, sample_meta_file, quiet = TRUE, mode = "wb", timeout = 30)
  }, error = function(e) {
    skip(paste("Could not download test data:", e$message))
  })

  expect_true(file.exists(counts_file), "Counts file should be downloaded")
  expect_true(file.exists(sample_meta_file), "Sample metadata file should be downloaded")

  # Copy main.R and run script to workspace
  repo_root <- normalizePath(file.path(dirname(getwd()), ".."))
  file.copy(file.path(repo_root, "code", "main.R"), file.path(code_dir, "main.R"))
  file.copy(file.path(repo_root, "code", "run"), file.path(code_dir, "run"))

  # Run the script from code directory
  old_wd <- getwd()
  setwd(code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  # Execute run script with explicit CLI arguments
  exit_code <- system2(
    "bash",
    args = c(
      "run",
      "--delim=,",
      "--regex_count=count.*\\.[ct]sv\\(\\.gz\\)?",
      "--regex_sample=sample.*\\.[ct]sv\\(\\.gz\\)?"
    )
  )

  # Check for successful execution
  expect_equal(exit_code, 0, info = "run script should execute without error")
  expect_true(file.exists(file.path(results_dir, "moo", "moo-raw.rds")),
              "Output file moo-raw.rds should be created")

  # Validate output is a valid MOO object
  moo <- readr::read_rds(file.path(results_dir, "moo", "moo-raw.rds"))
  expect_true(
    S7::S7_inherits(moo, MOSuite::multiOmicDataSet),
    info = "Output should be an S7 multiOmicDataSet object"
  )
})