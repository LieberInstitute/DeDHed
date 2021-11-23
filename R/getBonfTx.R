#' Title
#'
#' @param covComb_tx
#'
#' @return
#' @export
#' @importFrom stats prcomp
#' @importFrom SummarizedExperiment assays
#' @examples
getBonfTx<- function(covComb_tx){
        qsvBonf_tx<-prcomp(t(log2(assays(covComb_tx)$tpm+1)))
}
