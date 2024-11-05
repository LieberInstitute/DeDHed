#' Select transcripts associated with degradation
#'
#' Helper function to select which experimental model will be used to generate the qSVs.
#'
#' @param type A `character(1)` specifying the transcripts set type.
#' These were determined by Joshua M. Stolz
#' et al, 2022. Here the names "cell_component", "top1500", and "top1000" refer
#' to models that were determined to be effective in removing degradation
#' effects. The "top1000" model involves taking the union of the top 1000
#' transcripts associated with degradation from the interaction model and the
#' main effect model. The "top1500" model is the same as the "top1000" model
#' except the union of the top 1500 genes associated with degradation is
#' selected. The most effective of our models, "cell_component", involved
#' deconvolution of the degradation matrix to determine the proportion of cell
#' types within our studied tissue. These proportions were then added to our
#' `model.matrix()` and the union of the top 1000 transcripts in the interaction
#' model, the main effect model, and the cell proportions models (main and
#' interaction) were used to generate this model of qSVs.
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
select_transcripts <- function(type = c("cell_component", "top1500", "top1000")) {
    type <- match.arg(type)
    if (type == "cell_component") {
        return(qsvaR::transcripts$cell_component)
    } else if (type == "top1500") {
        return(qsvaR::transcripts$tx1500)
    } else if (type == "top1000") {
        return(qsvaR::transcripts$standard)
    }
}
