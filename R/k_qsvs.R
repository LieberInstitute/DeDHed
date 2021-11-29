

#' Apply num.sv algorithm to determine the number of pcs to be included
#'
#'
#'
#' @param covComb_tx Ranged Summarizeed Experiment with only trancsripts selected for qsva
#' @param mod_tx  Model Matrix with necessary variables the you would model for in differential expression
#'
#' @return integer representing number of pcs to be included
#' @export
#' @importFrom sva num.sv
#' @importFrom SummarizedExperiment assays
#' @examples
#' ##TODO
#'
k_qsvs<- function(covComb_tx, mod_tx){
        k = num.sv(log2(assays(covComb_tx)$tpm), mod_tx)
}
