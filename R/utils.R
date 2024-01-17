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
#' sig_transcripts = select_transcripts("cell_component")
#' check_tx_names(rownames(covComb_tx_deg), sig_transcripts, 'rownames(covComb_tx_deg)', 'sig_transcripts')


check_tx_names = function(tx1, tx2, arg_name1, arg_name2) {
  #   Functions for checking whether a vector of transcripts all match GENCODE
  #   or ENSEMBL naming conventions
  is_gencode = function(x) all(grepl("^ENST.*?\\.", x))
  is_ensembl = function(x) all(grepl("^ENST", x) & !grepl("\\.", x))
  
  #   Check that both vectors either follow GENCODE or ENSEMBL
  if (!is_gencode(tx1) && !is_ensembl(tx1)) {
    stop(
      sprintf(
        "'%s' must use either all GENCODE or all ENSEMBL transcript IDs",
        arg_name1
      )
    )
  }
  if (!is_gencode(tx2) && !is_ensembl(tx2)) {
    stop(
      sprintf(
        "'%s' must use either all GENCODE or all ENSEMBL transcript IDs",
        arg_name2
      )
    )
  }
  
  #   Change 'tx2' to match 'tx1', noting that the case where 'tx1' is GENCODE
  #   but 'tx2' is ENSEMBL is not allowed (and an error will be thrown further
  #   down)
  if (is_gencode(tx2) && is_ensembl(tx1)) {
    tx2 = sub('\\..*', '', tx2)
  }
  
  #   At least some transcripts must overlap between 'tx1' and 'tx2'
  if (!any(tx2 %in% tx1)) {
    stop(sprintf("None of '%s' are in '%s'", arg_name2, arg_name1))
  }
  
  #   Since only 'tx2' was modified, return the changed copy
  return(tx2)
}