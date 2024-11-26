# ENSEMBL names that are not GENCODE or ENSEMBL

# Test for which_tx_names transcripts throw errors if annotation is not GENCODE or ENSEMBL
test_that("check_tx_names throw error if annotation is not GENCODE or ENSEMBL", {
    # For testing the error condition, altered manually rownames of rse_tx
    altered_rse_tx <- rse_tx
    rownames(altered_rse_tx) <- paste0("gene", 1:length(rownames(altered_rse_tx)))
    sig_transcripts <- select_transcripts(cell_component = TRUE)
    expect_error(which_tx_names(rownames(altered_rse_tx), sig_transcripts))
    expect_error(which_tx_names(sig_transcripts, rownames(altered_rse_tx)))
})
