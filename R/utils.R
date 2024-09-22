


#' Remove version number from Gencode/Ensembl transcript names
#'
#' This function removes the Gencode/ENSEMBL version from the transcript ID, while protecting _PAR_Y suffixes if present
#'
#' @param txnames A `character()` vector of GENCODE or ENSEMBL transcript IDs
#'
#'
#' @return A
#'  `character()` vector of transcript names without versioning
#'
#' @export
#'
#' @examples
#' ensIDs <-  normalize_tx_names(rownames(rse_tx))

normalize_tx_names <- function(txnames) {
  sub('(ENST\\d+)\\.\\d+(.*)$','\\1\\2', txnames, perl=TRUE)
}


#' Check validity of transcript vectors and return a vector matching indexes in tx1
#'
#' This function is used to check if tx1 and tx2 are GENCODE or ENSEMBL transcript IDs
#' and return an integer vector of tx1 transcript indexes that are in tx2.
#'
#' @param tx1 A `character()` vector of GENCODE or ENSEMBL transcript IDs.
#' @param tx2 A `character()` vector of GENCODE or ENSEMBL transcript IDs.
#'
#'
#' @return A
#'  `integer()` vector of `tx1` transcript indexes in `tx2`.
#'
#' @export
#'
#' @examples
#' sig_tx <-  select_transcripts("cell_component")
#' whichTx <- which_tx_names(rownames(rse_tx), sig_tx)

which_tx_names = function(txnames, sig_transcripts) {
  ## Between releases 25 and 43, PAR genes and transcripts had the "_PAR_Y" suffix appended to their identifiers.
  ## Since release 44, these have their own IDs
  if (!all(grepl("^ENST\\d+", txnames))) {
    stop("The transcript names must be ENSEMBL or Gencode IDs (ENST...)" )
  }
  ## normalize the transcript names
  r_tx <- normalize_tx_names(txnames)
  sig_tx <- normalize_tx_names(sig_transcripts)
  which(r_tx %in% sig_tx)
}

