#' A wrapper function used to perform qSVA in one step.
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] object containing
#' the transcript data desired to be studied.
#' @param type a character string specifying which model you would
#'  like to use when selecting a degradation matrix.
#' @param sig_transcripts A list of transcripts that are associated with
#' degradation signal. Use `select_transcripts()` to select sets of transcripts
#' identified by the qSVA expanded paper. Specifying a `character()` input of
#' ENSEMBL transcript IDs obtained outside of `select_transcripts()` overrides
#' the user friendly `type` argument. That is, this argument provides more fine
#' tuning options for advanced users.
#' @param mod Model Matrix with necessary variables the you would
#'  model for in differential expression
#' @param assayname character string specifying the name of
#'  the assay desired in rse_tx
#'
#' @return matrix with k principal components for each sample
#' @export
#'
#' @examples
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'     data = colData(covComb_tx_deg)
#' )
#' qSVA(rse_tx = covComb_tx_deg, type = "cell_component", mod = mod, assayname = "tpm")
#'
qSVA <- function(rse_tx, type = "cell_component", sig_transcripts = select_transcripts(type), mod, assayname) {
    ## We don't need to pass type to getDegTx() since it's not used internally
    ## once the sig_transcripts have been defined.
    DegTx <- getDegTx(rse_tx, sig_transcripts = sig_transcripts)
    PCs <- getPCs(DegTx, assayname)
    k <- k_qsvs(DegTx, mod = mod, assayname = assayname)
    qSV <- get_qsvs(PCs, k)
    return(qSV)
}
