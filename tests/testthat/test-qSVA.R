mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(covComb_tx_deg))


test_that("number of qsvs is k", {
    expect_equal(length(colnames(qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm"))), 10)
})

test_that("length of qsv rownames is the same as number of samples", {
    expect_equal(length(rownames(qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm"))), length(colnames(covComb_tx_deg)))
})

test_that("output is a matrix", {
    expect_equal(class(qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm"))[1], "matrix")
})

test_that("output is an RSE", {
    expect_equal(class(qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm"))[2], "array")
})
