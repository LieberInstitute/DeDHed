#' Check validity of transcript vectors

#' @export


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