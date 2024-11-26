# Filter out lowly expressed transcripts and test if the number of rows in getDegTx output matches expected transcript count
rse_tx_low <- rse_tx[rowMeans(assays(rse_tx)$tpm) < 1, ]
test_that("length for number of rows is the same as length sig_transcripts", {
    expect_equal(
        nrow(getDegTx(rse_tx)),
        length(intersect(rownames(rse_tx), select_transcripts()))
    )
})

# Test if number of columns in getDegTx output matches number of columns in original dataset
test_that("length for number of columns is the same a length sig_transcripts", {
    expect_equal(length(colnames(getDegTx(rse_tx))), length(colnames(rse_tx)))
})

# Test if getDegTx returns an object of the same class as its input
test_that("output is an RSE", {
    expect_equal(class(getDegTx(rse_tx)), class(rse_tx))
})

# Test for a warning when getDegTx is used on a dataset with lowly expressed transcripts
test_that("test warning output for lowly expressed transcripts", {
    expect_warning(
        getDegTx(rse_tx_low, verbose = FALSE),
        "The transcripts selected are lowly expressed in your dataset. This can impact downstream analysis."
    )
})

# Test for rownames starting with "ENST"
test_that("getDegTx correctly processes rse_tx", {
    # If rse_tx is correctly structured and all rownames start with "ENST", expect no error
    expect_silent(getDegTx(rse_tx, verbose = FALSE))
})


# Test whether getDegTx gives the same results with original and altered row names
test_that("getDegTx works with original and altered row names", {
    set.seed(123)
    # Apply getDegTx to rse_tx
    original_results <- getDegTx(rse_tx, sig_transcripts = select_transcripts(cell_component = TRUE))

    # Alter the row names of rse_tx and apply getDegTx
    altered_rse_tx <- rse_tx
    rownames(altered_rse_tx) <- gsub("\\..\\d+", "", rownames(rse_tx))
    altered_results <- getDegTx(altered_rse_tx, sig_transcripts = select_transcripts(cell_component = TRUE))
    rownames(altered_results) <- rownames(original_results)
    # Test if two objects identical
    expect_identical(original_results, altered_results)
})

# Test for assayname not in assayNames
test_that("getDegTx throws an error when assayname is not in assayNames", {
    expect_error(getDegTx(rse_tx, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})

# Test for input is an rse object
test_that("getDegTx throws an error when input is not a RangedSummarizedExperiment object", {
    qsv <- list(x = matrix(seq_len(9), ncol = 3))
    expect_error(getDegTx(qsv, assayname = "tpm"), "'rse_tx' must be a RangedSummarizedExperiment object.")
})
