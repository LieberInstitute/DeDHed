#' Select degradation related transcripts
#'
#' TODO Description
#'
#' @param type A `character(1)` specifying the transcripts set type. These
#' were determined by Joshua M. Stolz et al, 2022.
#'
#' @return A `character()` with the transcript IDs.
#' @export
#'
#' @examples
#' select_transcripts()
select_transcripts <- function(type) {
    rownames(covComb_tx_deg)
}
