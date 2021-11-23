#' TODO
#'
#'  Description TODO.
#'
#'
#' @param qsvBonf_tx TODO
#' @param k TODO
#'
#' @return
#' @export
#'
#' @examples
#' qsv <- list(x=matrix(seq_len(9),ncol=3))
#' get_qsvs(qsv, 2)
get_qsvs<-function(qsvBonf_tx, k){
    qSVs_tx<-qsvBonf_tx$x[, seq_len(k)]
    return(qSVs_tx)
}
