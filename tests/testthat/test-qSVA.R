mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(covComb_tx_deg))

## Run qSVA with 2 types
set.seed(20230621)
qsva_cc <- qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm")
set.seed(20230621)
qsva_standard <- qSVA(rse_tx = covComb_tx_deg, type = "standard", mod = mod, assayname = "tpm")

test_that("number of qsvs is k", {
    expect_equal(length(colnames(qsva_cc)), 10)
    expect_equal(length(colnames(qsva_standard)), 8)
})

test_that("length of qsv rownames is the same as number of samples", {
    expect_equal(length(rownames(qsva_cc)), length(colnames(covComb_tx_deg)))
})

test_that("output is a matrix", {
    expect_equal(class(qsva_cc)[1], "matrix")
})

test_that("output is an array", {
    expect_equal(class(qsva_cc)[2], "array")
})
