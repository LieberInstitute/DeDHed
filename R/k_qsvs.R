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
#' @import SummarizedExperiment
#' @examples
#' ## First we need to define a statistical model. We'll use the example
#' ## rse_tx data. Note that the model you'll use in your own data
#' ## might look different from this model.
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'     data = colData(rse_tx)
#' )
#'
#' ## To ensure that the results are reproducible, you will need to set a
#' ## random seed with the set.seed() function. Internally, we are using
#' ## sva::num.sv() which needs a random seed to ensure reproducibility of the
#' ## results.
#' set.seed(20230621)
#' k_qsvs(rse_tx, mod, "tpm")
k_qsvs <- function(rse_tx, mod, assayname) {
    # Validate rse_tx is a RangedSummarizedExperiment object
    if (!is(rse_tx, "RangedSummarizedExperiment")) {
        stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
    }

    # Check if assayname is in assayNames
    if (!assayname %in% assayNames(rse_tx)) {
        stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
    }

    # Check if mod is a matrix
    if (!is(mod, "matrix")) {
        stop("'mod' must be a matrix.", call. = FALSE)
    }

    # Check if mod is full rank
    if (qr(mod)$rank != ncol(mod)) {
        stop("The 'mod' matrix is not full rank.", call. = FALSE)
    }
    if (nrow(mod) != ncol(rse_tx)) {
        stop("The number of rows in 'mod' does not match the number of input 'rse_tx' columns.", call. = FALSE)
    }

    # Get expression data normalized by log2
    expr <- log2(assays(rse_tx)[[assayname]] + 1)

    # Run num.sv
    k <- tryCatch(
        num.sv(expr, mod),
        error = function(e) {
            if (grepl("only 0's may be mixed with negative subscripts", e$message)) {
                warning("Could not run sva::num.sv(). Likely due to transcripts being not expressed in most samples.", call. = FALSE)
            } else if (grepl("system is computationally singular", e$message)) {
                warning("Could not run sva::num.sv(). Likely due to having highly correlated variables in your 'mod'.", call. = FALSE)
            } else {
                warning("Could not run sva::num.sv().", call. = FALSE)
            }
            stop(e)
        }
    )
    return(k)
}
