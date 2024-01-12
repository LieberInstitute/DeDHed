test_that("output is a prcomp", {
    expect_equal(class(getPCs(covComb_tx_deg, "tpm")), "prcomp")
})

test_that("check for assayname break", {
    expect_error(getPCs(covComb_tx_deg, "NA"))
})

# Test for assayname not in assayNames
test_that("getDegTx throws an error when assayname is not in assayNames", {
  expect_error(getPCs(covComb_tx_deg, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})
