test_that("create_plot handles valid and invalid IDs", {
  # Setup: Load data
  data("fp", package = "fp", envir = environment())
  data("fp.df.web", package = "fp", envir = environment())
  
  # Source code using app_sys if available, otherwise relative path
  source_file <- function(path) {
    full_path <- system.file(path, package = "fp")
    if (full_path == "") {
      # Fallback for devtools::test() if system.file doesn't find it in inst/
      full_path <- file.path("../../inst", path)
    }
    if (file.exists(full_path)) {
      source(full_path)
    } else {
      # Second fallback if we are already in the package root
      full_path <- file.path("inst", path)
      if (file.exists(full_path)) {
        source(full_path)
      }
    }
  }
  
  source_file("app_code/custom_ggplot_axis.R")
  source_file("app_code/plot_fp.r")

  # Test Valid ID
  p_valid <- create_plot(id = 5, data = fp, id_data = fp.df.web)
  expect_s3_class(p_valid, "ggplot")

  # Test NULL ID (should not crash)
  p_null <- create_plot(id = NULL, data = fp, id_data = fp.df.web)
  expect_s3_class(p_null, "ggplot")
  expect_equal(p_null$layers[[1]]$aes_params$label, "Please select a valid ID")

  # Test ID that doesn't exist
  p_missing <- create_plot(id = "99999", data = fp, id_data = fp.df.web)
  expect_s3_class(p_missing, "ggplot")
  expect_true(grepl("not found", p_missing$layers[[1]]$aes_params$label))

  # Test empty character vector
  p_empty <- create_plot(id = character(0), data = fp, id_data = fp.df.web)
  expect_s3_class(p_empty, "ggplot")
  expect_equal(p_empty$layers[[1]]$aes_params$label, "Please select a valid ID")
})
