#' SomeTITLE
#'
#'  TODO some description.
#'
#'
#' @param covComb_tx TODO
#'
#' @return
#' @export
#' @importFrom stats prcomp
#' @importFrom SummarizedExperiment assays
#' @examples
#'  ## TODO
getBonfTx<- function(covComb_tx){
        qsvBonf_tx<-prcomp(t(log2(assays(covComb_tx)$tpm+1)))
}
