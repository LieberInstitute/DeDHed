mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN, data = colData(covComb_tx_deg))

# rse_tx_low has low expression
rse_tx_low <- covComb_tx_deg[rowMeans(assays(covComb_tx_deg)$tpm) < 1, ]

# mod2 is not full rank
mod2 <- mod
mod2 <- cbind(mod2, 1 - mod[, "mitoRate"])
colnames(mod2)[8] <- "mitotest"

## Set a random seed
set.seed(20230621)
k_res <- k_qsvs(covComb_tx_deg, mod, "tpm")

test_that("length pf output is 1", {
    expect_equal(length(k_res), 1)
})

test_that("test that output for example data k = 10", {
    expect_equal(k_res, 10)
})

test_that("output is an numeric", {
    expect_equal(class(k_res), "numeric")
})

# Test when number of rows in 'mod' does not match number of columns in 'rse_tx'
test_that("Number of rows in 'mod' does not match number of columns in 'rse_tx'", {
  mod_not_matching <- mod
  mod_not_matching <- mod_not_matching[-1, ]
  expect_error(k_qsvs(covComb_tx_deg, mod_not_matching, "tpm"), 
               "The number of rows in 'mod' does not match the number of input 'rse_tx' columns.")
})

test_that("non-full rank data throws error", {
    set.seed(20230621)
    expect_error(qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod2, assayname = "tpm"), "matrix is not full rank")
})


test_that("test that full rank matrix works correctly", {
    set.seed(20230621)
    # expect_warning(k_qsvs(rse_tx_low, mod, "tpm"), "Likely due to transcripts being not expressed in most samples")
    expect_silent(k_qsvs(covComb_tx_deg, mod, "tpm"))
})
