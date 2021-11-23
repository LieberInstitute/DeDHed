#' Title
#'
#' @param qsvBonf_tx
#' @param k
#'
#' @return
#' @export
#'
#' @examples
get_qsvs<-function(qsvBonf_tx, k){
    qSVs_tx<-qsvBonf_tx$x[, seq_len(k)]
    return(qSVs_tx)
}
