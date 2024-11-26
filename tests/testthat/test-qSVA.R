mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(rse_tx))

## Run qSVA with 2 types
set.seed(20230621)
qsva_cc <- qSVA(
    rse_tx = rse_tx,
    sig_transcripts = select_transcripts(cell_component = TRUE),
    mod = mod,
    assayname = "tpm"
)

qsva_standard <- qSVA(rse_tx = rse_tx, mod = mod, assayname = "tpm")

test_that("number of qsvs is k", {
    expect_equal(length(colnames(qsva_cc)), 10)
    expect_equal(length(colnames(qsva_standard)), 8)
})

test_that("length of qsv rownames is the same as number of samples", {
    expect_equal(length(rownames(qsva_cc)), length(colnames(rse_tx)))
})

test_that("output is a matrix", {
    expect_equal(class(qsva_cc)[1], "matrix")
})

test_that("output is an array", {
    expect_equal(class(qsva_cc)[2], "array")
})

# Test for assayname not in assayNames
test_that("qSVA throws an error when assayname is not in assayNames", {
    expect_error(qSVA(rse_tx, mod = mod, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})

# Test for input is an rse object
test_that("getDegTx throws an error when input is not a RangedSummarizedExperiment object", {
    qsv <- list(x = matrix(seq_len(9), ncol = 3))
    expect_error(getDegTx(qsv, assayname = "tpm"), "'rse_tx' must be a RangedSummarizedExperiment object.")
})
