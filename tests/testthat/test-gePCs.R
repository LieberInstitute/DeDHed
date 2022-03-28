
test_that("output is a prcomp", {
    expect_equal(class(getPCs(covComb_tx_deg, "tpm")), "prcomp")
})

test_that("check for assayname break", {
    expect_error(getPCs(covComb_tx_deg, "NA"))
})

