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


# Test where all sig_transcripts are in covComb_tx_deg rownames
test_that("All sig_transcripts are in rse_tx rownames", {
  sig_transcripts <- select_transcripts("cell_component")
  expect_silent({
    if (!any(sig_transcripts %in% rownames(covComb_tx_deg))) {
      stop("sig_transcripts and rownames(rse_tx) do not match")
    }
  })
})

# Test where none of the sig_transcripts are in the rse_tx rownames
test_that("No sig_transcripts are in rse_tx rownames", {
  sig_transcripts <- c("gene4", "gene5", "gene6")
  expect_error({
    if (!any(sig_transcripts %in% rownames(covComb_tx_deg))) {
      stop("sig_transcripts and rownames(rse_tx) do not match")
    }
  }, "sig_transcripts and rownames(rse_tx) do not match")
})

test_that("getDegTx works with original and altered row names", {
  # Apply getDegTx to covComb_tx_deg
  original_results <- getDegTx(covComb_tx_deg,select_transcripts("cell_component"))
  
  # Alter the row names of covComb_tx_deg and apply getDegTx
  altered_covComb_tx_deg <- covComb_tx_deg
  rownames(altered_covComb_tx_deg) <- gsub("\\..*", "", rownames(covComb_tx_deg))
  altered_results <- getDegTx(altered_covComb_tx_deg,select_transcripts("cell_component"))
  
  # Test if the results are equivalent
  expect_equivalent(original_results, altered_results)
})