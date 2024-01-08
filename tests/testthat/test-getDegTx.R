# Filter out lowly expressed transcripts and test if the number of rows in getDegTx output matches expected transcript count
rse_tx_low <- covComb_tx_deg[rowMeans(assays(covComb_tx_deg)$tpm) < 1, ]
test_that("length for number of rows is the same a length sig_transcripts", {
    expect_equal(length(rownames(getDegTx(covComb_tx_deg))), length(select_transcripts("cell_component")))
})

# Test if number of columns in getDegTx output matches number of columns in original dataset
test_that("length for number of columns is the same a length sig_transcripts", {
    expect_equal(length(colnames(getDegTx(covComb_tx_deg))), length(colnames(covComb_tx_deg)))
})

# Test if getDegTx returns an object of the same class as its input
test_that("output is an RSE", {
    expect_equal(class(getDegTx(covComb_tx_deg)), class(covComb_tx_deg))
})

# Test for a warning when getDegTx is used on a dataset with lowly expressed transcripts
test_that("test warning output for lowly expressed transcripts", {
    expect_warning(getDegTx(rse_tx_low))
})

# Test for rownames starting with "ENST"
test_that("getDegTx correctly processes covComb_tx_deg", {
  # If covComb_tx_deg is correctly structured and all rownames start with "ENST", expect no error
  expect_silent(getDegTx(covComb_tx_deg))
  # For testing the error condition, altered manually rownames of covComb_tx_deg
  altered_covComb_tx_deg <- covComb_tx_deg
  rownames(altered_covComb_tx_deg)[1] <- "INVALID0001" # Change the first rowname to an invalid one
  
  # Expect an error when rownames do not start with "ENST"
  expect_error(getDegTx(altered_covComb_tx_deg), "Error: Some rownames do not start with 'ENST'.")
})


# Test where at least one sig_transcript is in covComb_tx_deg rownames
test_that("At least one sig_transcript is in covComb_tx_deg rownames", {
  sig_transcripts <- select_transcripts("cell_component")
  expect_silent({
    # Check if any of the sig_transcripts are in covComb_tx_deg rownames
    if (!any(sig_transcripts %in% rownames(covComb_tx_deg))) {
      stop("No sig_transcripts found in rownames(covComb_tx_deg)")
    }
  })
})

# Test where none of the sig_transcripts are in the covComb_tx_deg rownames
test_that("No sig_transcripts are in covComb_tx_deg rownames", {
  sig_transcripts <- c("gene4", "gene5", "gene6") # Example genes not in covComb_tx_deg
  expect_error({
    # Check if any of the sig_transcripts are in covComb_tx_deg rownames
    if (!any(sig_transcripts %in% rownames(covComb_tx_deg))) {
      stop("No sig_transcripts found in rownames(covComb_tx_deg)")
    }
  }, "No sig_transcripts found in rownames(covComb_tx_deg)")
})

# Test whether getDegTx gives the same results with original and altered row names
test_that("getDegTx works with original and altered row names", {
  set.seed(123)
  # Apply getDegTx to covComb_tx_deg
  original_results <- getDegTx(covComb_tx_deg,sig_transcripts =select_transcripts("cell_component"))
  
  # Alter the row names of covComb_tx_deg and apply getDegTx
  altered_covComb_tx_deg <- covComb_tx_deg
  rownames(altered_covComb_tx_deg) <- gsub("\\..*", "", rownames(covComb_tx_deg))
  altered_results <- getDegTx(altered_covComb_tx_deg,sig_transcripts =select_transcripts("cell_component"))
  rownames(altered_results) <- rownames(original_results)
  # Test if two objects identical
  expect_identical(original_results, altered_results)
})