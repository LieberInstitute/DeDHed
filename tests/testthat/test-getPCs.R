test_that("output is a prcomp", {
    expect_equal(class(getPCs(covComb_tx_deg, "tpm")), "prcomp")
})

# Test for assayname not in assayNames
test_that("getPCs throws an error when assayname is not in assayNames", {
  expect_error(getPCs(covComb_tx_deg, assayname = "not_in_assayNames"), "'not_in_assayNames' is not in assayNames\\(rse_tx\\).")
})
