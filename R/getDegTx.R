#' Funtion to obtain expression matrix for degraded transcripts
#'
#' This function is used to obtain a [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] of transcripts and their expression values #' These transcripts are selected based on a prior study of RNA degradation in postmortem brain tissues. This object can later be used to obtain the principle components
#' necessary to remove the effect of degradation in differential expression.
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] object containing
#' the transcript data desired to be studied.
#'
#' @param sig_transcripts A list of transcripts determined to haave degradation signal in the qsva expanded paper.
#'
#' @return A
#'  [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object.
#'
#' @export
#'
#' @examples
getDegTx<-function(rse_tx){
    covComb_tx<-rse_tx[rownames(rse_tx)%in%sig_transcripts,]
    return(covComb_tx)
}
