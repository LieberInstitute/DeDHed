#' A wrapper function used to perform qSVA in one step.
#'
#' @inheritParams getDegTx
#' @param mod Model Matrix with necessary variables the you would model for in
#' differential expression.
#'
#' @return matrix with k principal components for each sample
#' @export
#'
#' @examples
#' ## First we need to define a statistical model. We'll use the example
#' ## rse_tx data. Note that the model you'll use in your own data
#' ## might look different from this model.
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'     data = colData(rse_tx)
#' )
#'
#' ## To ensure that the results are reproducible, you will need to set a
#' ## random seed with the set.seed() function. Internally, we are using
#' ## sva::num.sv() which needs a random seed to ensure reproducibility of the
#' ## results.
#' set.seed(20230621)
#' qSVA(rse_tx = rse_tx, mod = mod, assayname = "tpm")
#'
qSVA <- function(
        rse_tx, sig_transcripts = select_transcripts(), mod, assayname
    ) {
    # Validate rse_tx is a RangedSummarizedExperiment object
    if (!is(rse_tx, "RangedSummarizedExperiment")) {
        stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
    }

    # Check if assayname is in assayNames
    if (!assayname %in% assayNames(rse_tx)) {
        stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
    }

    # Get the qSVs
    DegTx <-
        getDegTx(rse_tx, sig_transcripts = sig_transcripts, assayname = assayname)
    PCs <- getPCs(DegTx, assayname)
    k <- k_qsvs(DegTx, mod = mod, assayname = assayname)
    qSV <- get_qsvs(PCs, k)
    return(qSV)
}
