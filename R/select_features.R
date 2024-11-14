#' Select features associated with degradation
#'
#' Helper function to select which experimental model will be used to generate the qSVs.
#'
#' @param type A `character(1)` specifying the features set type.
#' @param feature A `character(1)` specifying the feature type ("transcripts" or "genes").
#' These were determined by Joshua M. Stolz
#' et al, 2022. Here the names "cell_component", "top1500", and "top1000" refer
#' to models that were determined to be effective in removing degradation
#' effects. The "top1000" model involves taking the union of the top 1000
#' features associated with degradation from the interaction model and the
#' main effect model. The "top1500" model is the same as the "top1000" model
#' except the union of the top 1500 features associated with degradation is
#' selected. The most effective of our models, "cell_component", involved
#' deconvolution of the degradation matrix to determine the proportion of cell
#' types within our studied tissue. These proportions were then added to our
#' `model.matrix()` and the union of the top 1000 features in the interaction
#' model, the main effect model, and the cell proportions models (main and
#' interaction) were used to generate this model of qSVs.
#'
#' @return A `character()` with the feature IDs.
#' @export
#'
#' @examples
#' ## Default set of features associated with degradation
#' sig_features <- select_features()
#' length(sig_features)
#' head(sig_features)
#'
#' ## Example where match.arg() auto-completes
#' select_features("top")
select_features <- function(type = c("cell_component", "top1500", "top1000", "standard"),
                        feature = c("transcripts", "genes")) {
    type <- match.arg(type)
    feature <- match.arg(feature)
    if (feature == "transcripts") {
        if (type == "cell_component") {
            return(qsvaR::transcripts$cell_component)
        } else if (type == "top1500") {
            return(qsvaR::transcripts$tx1500)
        } else if (type == "top1000" || type == "standard") {
            return(qsvaR::transcripts$standard)
        }
    } else if (feature == "genes") {
        if (type == "cell_component") {
            return(qsvaR::genes$cell_component)
        } else if (type == "top1500") {
            return(qsvaR::genes$gene1500)
        } else if (type == "top1000" || type == "standard") {
            return(qsvaR::genes$standard)
        }
    }
}
