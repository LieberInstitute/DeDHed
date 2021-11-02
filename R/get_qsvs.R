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
    qSVs_tx<-qsvBonf_tx$x[, 1:k]
    print(getPcaVars(qsvBonf_tx)[1:k])
    return(qSVs_tx)
}
