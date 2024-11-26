#' Select transcripts associated with degradation
#'
#' Helper function to select which experimental model(s) will be used to
#' generate the qSVs. Degradation-associated transcripts are derived in four
#' different models (\link{transcripts}). The `cell_component` parameter
#' controls whether the models with cell-type proportions are included. This
#' function extract the top `top_n` transcripts found to be significant in
#' each considered model, then returns the union of transcripts across all
#' considered models. Up to 10,000 transcripts are available to select from
#' each model prior to taking the union.
#' 
#' @param top_n An `integer(1)` specifying how many significant transcripts to
#' extract from each model prior to taking a union across models.
#' @param cell_component A `logical(1)`. If `FALSE`, only include transcripts
#' from the main and interaction models (see `main_model` and `int_model`
#' here: \link{transcripts}). If `TRUE`, additionally include main and
#' interaction models that include cell-type proportions (a total of 4 models).
#'
#' @return A `character()` with the transcript IDs.
#' @export
#' 
#' @importFrom dplyr pull slice_head
#'
#' @examples
#' ## Default set of transcripts associated with degradation
#' sig_transcripts <- select_transcripts()
#' length(sig_transcripts)
#' head(sig_transcripts)
#'
#' ## Select more transcripts if desired
#' length(select_transcripts(top_n = 5000))
select_transcripts <- function(top_n = 1000, cell_component = FALSE) {
    if (top_n > 10000) {
        stop("'top_n' currently must not exceed 10,000", call. = FALSE)
    }

    non_cell_tx = union(
        qsvaR::transcripts$main_model |>
            dplyr::slice_head(n = top_n) |>
            dplyr::pull(tx),
        qsvaR::transcripts$int_model |>
            dplyr::slice_head(n = top_n) |>
            dplyr::pull(tx)
    )

    if (cell_component) {
        cell_tx = union(
            qsvaR::transcripts$cell_main_model |>
                dplyr::slice_head(n = top_n) |>
                dplyr::pull(tx),
            qsvaR::transcripts$cell_int_model |>
                dplyr::slice_head(n = top_n) |>
                dplyr::pull(tx)
        )
        return(union(non_cell_tx, cell_tx))
    } else {
        return(non_cell_tx)
    }
}
