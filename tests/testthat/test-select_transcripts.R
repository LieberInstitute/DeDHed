test_that("check that top1500 is generated correctly", {
    expect_equal(length(select_transcripts("top1500")), length(transcripts$tx1500))
})

test_that("check that cell component is generated correctly", {
    expect_equal(length(select_transcripts("cell_component")), length(transcripts$cell_component))
})

test_that("check that standard model is generated correctly", {
    expect_equal(length(select_transcripts("standard")), length(transcripts$standard))
})

test_that("check that TOP1500 (caps) is generated correctly", {
    expect_equal(length(select_transcripts("TOP1500")), length(transcripts$tx1500))
})

test_that("check that cell component with all caps is generated correctly", {
    expect_equal(length(select_transcripts("CELL_COMPONENT")), length(transcripts$cell_component))
})

test_that("check that STANDARD (caps) model is generated correctly", {
    expect_equal(length(select_transcripts("STANDARD")), length(transcripts$standard))
})
