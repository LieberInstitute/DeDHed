# ENSEMBL names that are not GENCODE or ENSEMBL

# Test for check_tx_names transcripts throw errors if annotation is not GENCODE or ENSEMBL
test_that("check_tx_names throw error if annotation is not GENCODE or ENSEMBL", {
  # For testing the error condition, altered manually rownames of covComb_tx_deg
  altered_covComb_tx_deg <- covComb_tx_deg
  rownames(altered_covComb_tx_deg) <- paste0("gene", 1:length(rownames(altered_covComb_tx_deg))) 
  sig_transcripts <- select_transcripts("cell_component")
  expect_error(check_tx_names(rownames(altered_covComb_tx_deg), sig_transcripts, 'rownames(rse_tx)', 'sig_transcripts'), "rownames\\(rse_tx\\)' must use either all GENCODE or all ENSEMBL transcript IDs")
})

