#' TODO
#'
#'  Description TODO.
#'
#'
#' @param qsvBonf_tx S4 object of pricipal comoponents that make up the qsvs
#' @param k number of qsvs to be included.
#'
#' @return matrix with k principal components for each sample.
#' @export
#'
#' @examples
#' qsv <- list(x=matrix(seq_len(9),ncol=3))
#' get_qsvs(qsv, 2)
get_qsvs<-function(qsvBonf_tx, k){
    qSVs_tx<-qsvBonf_tx$x[, seq_len(k)]
    return(qSVs_tx)
}
