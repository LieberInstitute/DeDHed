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

# Test if the input is a dataframe
test_that("Input to DEqual is a dataframe", {
  
  DEqual(random_de)
  
  # Test if the input is a dataframe
  expect_true(is.data.frame(random_de), "The input to DEqual is not a dataframe.")
})

# Test that the output is a ggplot object
test_that("output is a ggplot", {
    expect_equal(class(DEqual(random_de))[1], "gg")
})

# Test that the output is a ggplot object
test_that("output is a ggplot", {
    expect_equal(class(DEqual(random_de))[2], "ggplot")
})


