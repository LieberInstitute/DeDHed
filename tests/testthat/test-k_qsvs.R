mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(covComb_tx_deg))

test_that("length pf output is 1", {
  expect_equal(length(k_qsvs(covComb_tx_deg, mod, "tpm")), 1)
})

test_that("test that output for example data k = 10", {
  expect_equal((k_qsvs(covComb_tx_deg, mod, "tpm")), 10)
})

test_that("output is an numeric", {
  expect_equal(class(k_qsvs(covComb_tx_deg, mod, "tpm")), "numeric")
})
