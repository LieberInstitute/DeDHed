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

