random_de <- data.frame(
    t = rt(nrow(degradation_tstats), 5),
    row.names = sample(rownames(degradation_tstats), nrow(degradation_tstats))
)


test_that("output is a ggplot", {
  expect_equal(class(DEqual(random_de))[1], "gg")
})

test_that("output is a ggplot", {
  expect_equal(class(DEqual(random_de))[2], "ggplot")
})

