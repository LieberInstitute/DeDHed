#' Title
#'
#' @param covComb_tx
#'
#' @return
#' @export
#'
#' @examples
getBonfTx<- function(covComb_tx){
        qsvBonf_tx<-prcomp(t(log2(assays(covComb_tx)$tpm+1)))
}
