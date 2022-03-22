mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(covComb_tx_deg))
k <- k_qsvs(covComb_tx_deg, mod, "tpm")
qsv <- getPCs(covComb_tx_deg, "tpm")

test_that("number of qsvs is k", {
    expect_equal(length(colnames(get_qsvs(qsv, k))), k)
})

test_that("length of qsv rownames is the same as number of samples", {
    expect_equal(length(rownames(get_qsvs(qsv, k))), length(colnames(covComb_tx_deg)))
})

test_that("output is a matrix", {
    expect_equal(class(get_qsvs(qsv, k))[1], "matrix")
})

test_that("output is an RSE", {
    expect_equal(class(get_qsvs(qsv, k))[2], "array")
})
