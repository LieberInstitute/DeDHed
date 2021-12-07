

#' Apply num.sv algorithm to determine the number of pcs to be included
#'
#'
#'
#' @param covComb_tx Ranged Summarizeed Experiment with only trancsripts selected for qsva
#' @param mod_tx  Model Matrix with necessary variables the you would model for in differential expression
#' @param assayname character string specifying the name of the assay desired in covComb_tx
#'
#' @return integer representing number of pcs to be included
#' @export
#' @importFrom sva num.sv
#' @importFrom SummarizedExperiment assays
#' @examples
#' mod_tx <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN , data = colData(covComb_tx_deg))
#' k_qsvs(covComb_tx_deg,mod_tx, "tpm")
k_qsvs<- function(covComb_tx, mod_tx,assayname){
        k = num.sv(log2(assays(covComb_tx)[[assayname]]+1), mod_tx)
        return(k)
}
