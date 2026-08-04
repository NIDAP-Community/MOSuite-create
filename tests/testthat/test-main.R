test_that("every app panel parameter is accepted and used by main.R", {
  repo_root <- normalizePath(
    file.path(testthat::test_path(), "..", ".."),
    mustWork = TRUE
  )
  panel <- jsonlite::fromJSON(
    file.path(repo_root, ".codeocean", "app-panel.json")
  )
  main_text <- paste(
    readLines(file.path(repo_root, "code", "main.R"), warn = FALSE),
    collapse = "\n"
  )
  param_names <- panel$parameters$param_name
  expect_true(length(param_names) > 0)
  for (param_name in param_names) {
    expect_match(
      main_text,
      sprintf('"--%s"', param_name),
      fixed = TRUE,
      info = sprintf("main.R should define a --%s CLI argument", param_name)
    )
    expect_match(
      main_text,
      sprintf("args$%s", param_name),
      fixed = TRUE,
      info = sprintf("main.R should read args$%s", param_name)
    )
  }
})

test_that("app panel exposes advanced create parameters accepted by main.R", {
  repo_root <- normalizePath(
    file.path(testthat::test_path(), "..", ".."),
    mustWork = TRUE
  )
  panel <- jsonlite::fromJSON(
    file.path(repo_root, ".codeocean", "app-panel.json")
  )
  panel_params <- panel$parameters$param_name
  advanced_category <- panel$categories$id[panel$categories$name == "Advanced"]

  expect_length(advanced_category, 1)
  expect_true("count_type" %in% panel_params)
  expect_true("sample_id_colname" %in% panel_params)
  expect_true("feature_id_colname" %in% panel_params)
  expect_equal(
    panel$parameters$category[panel$parameters$param_name == "count_type"],
    advanced_category
  )
  count_type_block <- panel$parameters[
    panel$parameters$param_name == "count_type",
  ]
  expect_equal(count_type_block$type, "list")
  expect_equal(count_type_block$default_value, "raw")
  expect_equal(
    count_type_block$extra_data[[1]],
    c("raw", "clean", "filt", "norm", "batch")
  )
  expect_equal(
    panel$parameters$category[
      panel$parameters$param_name == "sample_id_colname"
    ],
    advanced_category
  )
  expect_equal(
    panel$parameters$category[
      panel$parameters$param_name == "feature_id_colname"
    ],
    advanced_category
  )
})

test_that("main.R CLI creates raw MOO output", {
  setup <- setup_cli_workspace("mosuite_create_test_")
  on.exit(unlink(setup$workspace, recursive = TRUE), add = TRUE)

  old_wd <- getwd()
  setwd(setup$code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  exit_code <- system2("Rscript", args = c("main.R", common_cli_args))
  expect_equal(exit_code, 0, info = "main.R should execute without error")

  expect_outputs_created(setup$results_dir)
})

test_that("run wrapper executes and creates raw MOO output", {
  setup <- setup_cli_workspace("mosuite_create_run_test_")
  on.exit(unlink(setup$workspace, recursive = TRUE), add = TRUE)

  file.copy(
    file.path(setup$repo_root, "code", "run"),
    file.path(setup$code_dir, "run"),
    overwrite = TRUE
  )

  old_wd <- getwd()
  setwd(setup$code_dir)
  on.exit(setwd(old_wd), add = TRUE)

  exit_code <- system2("bash", args = c("run", common_cli_args))
  expect_equal(exit_code, 0, info = "run script should execute without error")

  expect_outputs_created(setup$results_dir)
})
