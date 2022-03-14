#' A wrapper function used to perform qSVA in one step.
#'
#' @param rse_tx TODO
#' @param type TODO
#' @param sig_transcripts TODO
#' @param mod TODO
#' @param assayname TODO
#'
#' @return
#' @export
#'
#' @examples
#' TODO
qSVA<-function(rse_tx, type = "cell_component", sig_transcripts = select_transcripts(type), mod, assayname) {
    DegTx<- getDegTx(rse_tx, type = type)
    PCs<-getPCs(DegTx, assayname)
    k <- k_qsvs(DegTx, mod=mod, assayname=assayname)
    qSV<-get_qsvs(PCs, k)
    return(qSV)
}
