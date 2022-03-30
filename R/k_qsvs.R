#' Apply num.sv algorithm to determine the number of pcs to be included
#'
#'
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] object containing
#' the transcript data desired to be studied.
#' @param mod  Model Matrix with necessary variables the you would
#' model for in differential expression
#' @param assayname character string specifying the name of the assay desired in rse_tx
#'
#' @return integer representing number of pcs to be included
#' @export
#' @importFrom sva num.sv
#' @importFrom SummarizedExperiment assays
#' @examples
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'  data = colData(covComb_tx_deg))
#' k_qsvs(covComb_tx_deg, mod, "tpm")
#'
k_qsvs <- function(rse_tx, mod, assayname) {
    if (qr(mod)$rank != ncol(mod)) {
        stop("The 'mod' matrix is not full rank.", call. = FALSE)
    }

    expr <- log2(assays(rse_tx)[[assayname]] + 1)
    k <- tryCatch(
        num.sv(expr, mod),
        error = function(e) {
            stop("Could not run sva::num.sv(). Likely due to transcripts being not expressed in most samples.", call. = FALSE)
            return(NULL)
        }
    )
    return(k)
}
