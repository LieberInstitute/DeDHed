#' A wrapper function used to perform qSVA in one step.
#'
#' @param rse A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class]
#'  object containing the feature data desired to be studied.
#' @param type a character string specifying which model you would
#'  like to use from the sets of signature features identified
#'  by the qsvaR package. This can be omitted if a custom set of
#'  features is provided to sig_features.
#' @param sig_features A list of feature IDs that are associated
#'  with degradation signal. Specifying a `character()` input with ENSEMBL
#' feature IDs (whose values should match entries in `rownames(rse)`).
#' This argument provides a custom list of features for adjusting
#' for degradation; this should be used instead of the `type` argument.
#' @param mod Model Matrix with necessary variables the you would
#'  model for in differential expression
#' @param assayname character string specifying the name of
#'  the assay desired in rse
#'
#' @return matrix with k principal components for each sample
#' @export
#'
#' @examples
#' ## First we need to define a statistical model. We'll use the example
#' ## rse_tx data. Note that the model you'll use in your own data
#' ## might look different from this model.
#' mod <- model.matrix(~ mitoRate + Region + rRNA_rate + totalAssignedGene + RIN,
#'     data = colData(rse)
#' )
#'
#' ## To ensure that the results are reproducible, you will need to set a
#' ## random seed with the set.seed() function. Internally, we are using
#' ## sva::num.sv() which needs a random seed to ensure reproducibility of the
#' ## results.
#' set.seed(20230621)
#' qSVA(rse = rse, type = "cell_component", mod = mod, assayname = "tpm")
#'
qSVA <- function(rse, type = c("cell_component", "top1000", "top1500"),
                      sig_features = NULL, mod, assayname) {
    if (is.null(sig_features)) {
        type <- arg_match(type) # must be one of those in the list if sig_features is NULL
    }

    # Validate rse is a RangedSummarizedExperiment object
    if (!is(rse, "RangedSummarizedExperiment")) {
        stop("'rse' must be a RangedSummarizedExperiment object.", call. = FALSE)
    }

    # Check if assayname is in assayNames
    if (!assayname %in% assayNames(rse)) {
        stop(sprintf("'%s' is not in assayNames(rse).", assayname), call. = FALSE)
    }

    # Get the qSVs
    DegFeatures <- getDegFeatures(rse, type = type, sig_features = sig_features, assayname = assayname)
    PCs <- getPCs(DegFeatures, assayname)
    k <- k_qsvs(DegFeatures, mod = mod, assayname = assayname)
    qSV <- get_qsvs(PCs, k)
    return(qSV)
}
