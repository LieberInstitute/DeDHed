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

# Test if the input to DEqual is a dataframe
test_that("Input to DEqual is a dataframe", {
  
  DEqual(random_de)
  
  # Test if the input to DEqual is a dataframe
  expect_true(is.data.frame(random_de), "The input to DEqual is not a dataframe.")
})
 
# Test if DEqual throws an error when input is not a dataframe
test_that("DEqual throws an error for non-dataframe input", {
  # Test if DEqual throws an error when input is not a dataframe
  expect_error(DEqual(covComb_tx_deg), "Error: The input to DEqual is not a dataframe.")
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
  # For testing the error condition, altered manually rownames of random_de
  altered_random_de <- random_de
  rownames(altered_random_de)[1] <- "INVALID0001" # Change the first rowname to an invalid one
  
  # Expect an error when rownames do not start with "ENST"
  expect_error(DEqual(altered_random_de), "Error: Some rownames do not start with 'ENST'.")
})
