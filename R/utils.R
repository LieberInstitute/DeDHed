#' Check validity of transcript vectors
#'
#' This function is used to check if the tx1 and tx2 are GENCODE or ENSEMBL and print an error message if it's not and return a character vector of transcripts in tx2 that are in tx1.
#'
#' @param tx1 A `character()` vector of GENCODE or ENSEMBL transcripts.
#' @param tx2 A `character()` vector of GENCODE or ENSEMBL transcripts.
#'
#' @param arg_name1 A `character(1)` vector of description of tx1
#' @param arg_name2 A `character(1)` vector of description of tx2
#'
#' @return A
#'  `character()` vector of transcripts in `tx2` that are in `tx1`.
#'
#' @export
#'
#' @examples
#' sig_tx <-  select_transcripts("cell_component")
#' whichTx <- check_tx_names(rownames(rse_tx), sig_tx)

check_tx_names = function(txnames, sig_transcripts) {
  #   Functions for checking whether a vector of transcripts all match GENCODE
  #   or ENSEMBL naming conventions
  ## Between releases 25 and 43, PAR genes and transcripts had the "_PAR_Y" suffix appended to their identifiers.
  ## Since release 44, these have their own IDs
  if (!all(grepl("^ENST\\d+", txnames))) {
    stop("The transcript names must be ENSEMBL or Gencode IDs (ENST...)" )
  }
  ## normalize the transcript names
  sig_tx <- sub('(ENST\\d+)\\.\\d+(.*)$','\\1\\2', sig_transcripts, perl=TRUE)
  r_tx <- sub('(ENST\\d+)\\.\\d+(.*)$','\\1\\2', txnames, perl=TRUE)
  which(r_tx %in% sig_tx)
}
