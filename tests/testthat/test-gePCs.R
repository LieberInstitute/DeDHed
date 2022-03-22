
test_that("output is a prcomp", {
    expect_equal(class(getPCs(covComb_tx_deg, "tpm")), "prcomp")
})
