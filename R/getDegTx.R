#' Title
#'
#' @param rse_tx
#'
#' @return
#' @export
#'
#' @examples
getDegTx<-function(rse_tx){
    covComb_tx<-rse_tx[rownames(rse_tx)%in%sig_transcripts,]
    return(covComb_tx)
}
