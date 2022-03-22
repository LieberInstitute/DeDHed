#' Select transcripts associated with degradation
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
#' ## Default set of transcripts associated with degradation
#' sig_transcripts <- select_transcripts()
#' length(sig_transcripts)
#' head(sig_transcripts)
#'
#' ## Example where match.arg() auto-completes
#' select_transcripts("top")
select_transcripts <- function(type = c("cell_component", "top1500", "standard")) {
    type <- match.arg(type)
    if (type == "cell_component") {
        return(transcripts$cell_component)

    } else if (type == "top1500") {
        return(transcripts$tx1500)
    } else if (type == "standard") {
        return(transcripts$standard)
    }
}
