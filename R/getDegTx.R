#' Obtain expression matrix for degraded transcripts
#'
#' This function is used to obtain a [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  of transcripts and their expression values #' These transcripts are selected based on a prior study of RNA degradation in
#'   postmortem brain tissues. This object can later be used to obtain the principle components
#' necessary to remove the effect of degradation in differential expression.
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#' object containing the transcript data desired to be studied.
#' @param sig_transcripts A `character()` vector of transcripts that should be
#' associated with degradation, expected to be present in `rownames(rse_tx)`.
#' @param assayname character string specifying the name of the assay desired in rse_tx
#' @param verbose specify if the function should report how many model transcripts were matched
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
#' degTx <- getDegTx(rse_tx)
getDegTx <- function(
        rse_tx, sig_transcripts = select_transcripts(), assayname = "tpm",
        verbose = TRUE
    ) {
    # Validate rse_tx is a RangedSummarizedExperiment object
    if (!is(rse_tx, "RangedSummarizedExperiment")) {
        stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
    }

    # Check if assayname is in assayNames
    if (!assayname %in% assayNames(rse_tx)) {
        stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
    }

    # Check for validity and matching of tx names and return the tx subset indexes in rse_tx
    wtx <- which_tx_names(rownames(rse_tx), sig_transcripts)
    if (length(wtx) == 0) {
        stop(
            "No transcripts in 'sig_transcripts' match those found in 'rse_tx'.",
            call. = FALSE
        )
    }

    if (verbose) {
        message(
            sprintf(
                "Using %s degradation-associated transcripts." , length(wtx)
            )
        )
    }
    rse_tx <- rse_tx[wtx, , drop = FALSE]

    # Check if the row means is greater than 1
    if (mean(rowMeans(assays(rse_tx)[[assayname]])) < 1) {
        warning("The transcripts selected are lowly expressed in your dataset. This can impact downstream analysis.")
    }
    return(rse_tx)
}
