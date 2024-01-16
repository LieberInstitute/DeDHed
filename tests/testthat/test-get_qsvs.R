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
    expect_equal(class(get_qsvs(qsv, k)), c("matrix", "array"))
})

test_that("k is lower than 0 throws an error", {
    expect_error(get_qsvs(qsv, -1), paste("k must between 1 and",ncol(qsv$x)))
})

test_that("k is 0 throws an error", {
   expect_error(get_qsvs(qsv, 0), paste("k must between 1 and",ncol(qsv$x)))
})

test_that("k is higher than the number of columns throws an error", {
  k = ncol(qsv$x) + 1000
  expect_error(get_qsvs(qsv, k), paste("k must between 1 and",ncol(qsv$x)))
})

test_that("input has to be a prcomp", {
  expect_error(get_qsvs(covComb_tx_deg, 3), "qsvPCs must be a prcomp object.")
})