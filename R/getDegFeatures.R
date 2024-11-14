#' Obtain expression matrix for degraded transcripts
#'
#' This function is used to obtain a [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  of features and their expression values. These features are selected based on a
#'  prior study of RNA degradation in postmortem brain tissues. This object can
#'  later be used to obtain the principle components necessary to remove the effect
#'  of degradation in differential expression.
#'
#' @param rse A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object containing the feature data desired to be studied.
#' @param type A `character(1)` specifying the features set type.
#' These were determined by Joshua M. Stolz et al, 2022. Here the names "cell_component", "top1500",
#' and "top1000" refer to models that were determined to be effective in removing degradation effects.
#' The "top1000" model involves taking the union of the top 1000 features
#' associated with degradation from the interaction model and the main effect model.
#' The "top1500" model is the same as the "top1000 model except the
#' union of the top 1500 features associated with degradation is selected.
#' The most effective of our models, "cell_component", involved deconvolution of
#' the degradation matrix to determine the proportion of cell types within our studied tissue.
#' These proportions were then added to our `model.matrix()` and the union of the top 1000 features in the interaction model,
#' the main effect model, and the cell proportions model were used to generate this model of qSVs.
#'
#' @param sig_features A list of features determined to have degradation signal in the qsva expanded paper.
#' @param assayname character string specifying the name of the assay desired in rse
#' @param verbose specify if the function should report how many model features were matched
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#'
#' @export
#' @importFrom methods is
#' @import rlang
#'
#' @examples
#' degFeatures <- getDegFeatures(rse, "top1000")
getDegFeatures <- function(rse, type = c("cell_component", "top1000", "top1500"),
    sig_features = NULL, assayname = "tpm", verbose = TRUE) {
    feature <- ifelse(grepl("ENSG", rownames(rse)[1]), "genes", "transcripts")
    if (is.null(sig_features)) {
        type <- arg_match(type)
        sig_features <- select_features(type, feature)
    } else {
        type <- "custom"
    }
    # Validate rse_tx is a RangedSummarizedExperiment object
    if (!is(rse, "RangedSummarizedExperiment")) {
        stop("'rse' must be a RangedSummarizedExperiment object.", call. = FALSE)
    }

    # Check if assayname is in assayNames
    if (!assayname %in% assayNames(rse)) {
        stop(sprintf("'%s' is not in assayNames(rse).", assayname), call. = FALSE)
    }

    # Check for validity and matching of tx names and return the tx subset indexes in rse_tx
    wtx <- which_tx_names(rownames(rse), sig_features)
    if (length(wtx) == 0) {
        stop("No features found in the '", type, "' degradation model features")
    }

    if (verbose) {
        message("   '", type, "' degradation model transcripts found: ", length(wtx))
    }
    rse <- rse[wtx, , drop = FALSE]

    # Check if the row means is greater than 1
    if (mean(rowMeans(assays(rse)[[assayname]])) < 1) {
        warning("The features selected are lowly expressed in your dataset. This can impact downstream analysis.")
    }
    return(rse)
}
