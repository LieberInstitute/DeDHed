test_that(
    "select_transcripts() checks",
    {
        top_800 = select_transcripts(top_n = 800)
        top_1000 = select_transcripts(top_n = 1000)
        top_800_cell = select_transcripts(top_n = 800, cell_component = TRUE)
        top_1000_cell = select_transcripts(top_n = 1000, cell_component = TRUE)

        #   Certain transcript sets must be subsets of others
        expect_equal(all(top_800 %in% top_1000), TRUE)
        expect_equal(all(top_800 %in% top_800_cell), TRUE)
        expect_equal(all(top_800_cell %in% top_1000_cell), TRUE)

        #   Sanity checks about number of transcripts returned
        expect_equal(length(top_800) >= 800, TRUE)
        expect_equal(length(top_1000) >= 1000, TRUE)
    }
)
