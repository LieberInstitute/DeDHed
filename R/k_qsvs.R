#' Title
#'
#' @param covComb_tx
#' @param mod_tx
#'
#' @return
#' @export
#' @importFrom sva num.sv
#' @importFrom SummarizedExperiment assays
#' @examples
#'
#'
k_qsvs<- function(covComb_tx, mod_tx){
        k = num.sv(log2(assays(covComb_tx)$tpm), mod_tx)
}
