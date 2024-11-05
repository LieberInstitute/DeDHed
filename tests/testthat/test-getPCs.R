test_that("output is a prcomp", {
    expect_equal(class(getPCs(rse_tx, "tpm")), "prcomp")
})

# Test for assayname not in assayNames
test_that("getPCs throws an error when assayname is not in assayNames", {
    expect_error(getPCs(rse_tx, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})

# Test for input is an rse object
test_that("getDegTx throws an error when input is not a RangedSummarizedExperiment object", {
    qsv <- list(x = matrix(seq_len(9), ncol = 3))
    expect_error(getDegTx(qsv, assayname = "tpm"), "'rse_tx' must be a RangedSummarizedExperiment object.")
})
