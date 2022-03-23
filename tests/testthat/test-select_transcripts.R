test_that("check that top1500 is generated correctly", {
    expect_equal(length(select_transcripts("top1500")), length(transcripts$tx1500))
})

test_that("check that cell component is generated correctly", {
    expect_equal(length(select_transcripts("cell_component")), length(transcripts$cell_component))
})

test_that("check that standard model is generated correctly", {
    expect_equal(length(select_transcripts("standard")), length(transcripts$standard))
})

