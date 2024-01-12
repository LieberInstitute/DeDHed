# Create a data frame 'random_de'. This data frame is created by:
# 1. Generating a vector 't' with random t-distribution values. The 'rt' function is used to generate
#    these values, where 'nrow(degradation_tstats)' specifies the number of values and '5' is the degrees of freedom.
# 2. Setting the row names of 'random_de' to a random sample of the row names from 'degradation_tstats'.
#    'sample' function is used for sampling, and 'nrow(degradation_tstats)' gives the number of samples to draw.
# 3. The data frame 'random_de' is then used as input for the function 'DEqual' to generate a ggplot object.
random_de <- data.frame(
    t = rt(nrow(degradation_tstats), 5),
    row.names = sample(rownames(degradation_tstats), nrow(degradation_tstats))
)

# Test if DEqual throws an error when input is not a dataframe
test_that("DEqual throws an error for non-dataframe input", {
  # Test if DEqual throws an error when input is not a dataframe
  expect_error(DEqual(covComb_tx_deg), "The input to DEqual is not a dataframe.")
})

# Test when 't' is not in the columns
test_that("DE does not have column 't'", {
  DE_without_t <- random_de
  DE_without_t$t <- NULL
  expect_error(DEqual(DE_without_t), "'t' is not a column in DE.")
})

# Test that the output is a ggplot object
test_that("output is a ggplot", {
    expect_equal(class(DEqual(random_de))[1], "gg")
})

# Test that the output is a ggplot object
test_that("output is a ggplot", {
    expect_equal(class(DEqual(random_de))[2], "ggplot")
})

# Test for rownames starting with "ENST"
test_that("DEqual correctly processes random_de", {
  # If random_de is correctly structured and all rownames start with "ENST", expect no error
  expect_silent(DEqual(random_de))
})

# Test: None of the DE rownames are in degradation_tstats rownames
test_that("No DE rownames are in degradation_tstats rownames", {
  # Alter rownames of random_de to simulate non-matching genes
  altered_random_de <- random_de
  rownames(altered_random_de) <- paste0("gene", 1:length(rownames(random_de)))
  
  # Expect an error if rownames in altered_random_de don't match those in degradation_tstats
  expect_error({
    DEqual(altered_random_de)
  }, "'DE' and degradation t-statistics rownames mismatch error.")
})