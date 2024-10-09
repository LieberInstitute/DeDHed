#' A wrapper function used to perform qSVA in one step.
#'
#' @param rse_tx A [RangedSummarizedExperiment-class][SummarizedExperiment::RangedSummarizedExperiment-class] object containing
#' the transcript data desired to be studied.
#' @param type a character string specifying which model you would
#'  like to use from the sets of signature transcripts identified
#'  by the qsvaR package. This can be omitted if a custom set of
#'  transcripts is provided to sig_transcripts.
#' @param sig_transcripts A list of transcript IDs that are associated
#'  with degradation signal. Specifying a `character()` input with ENSEMBL
#' transcript IDs (whose values should match entries in `rownames(rse_tx)`).
#' This argument provides a custom list of transcripts for adjusting
#' for degradation; this should be used instead of the `type` argument.
#' @param mod Model Matrix with necessary variables the you would
#'  model for in differential expression
#' @param assayname character string specifying the name of
#'  the assay desired in rse_tx
#'
#' @return matrix with k principal components for each sample
#' @export
#'
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
#' qSVA(rse_tx = rse_tx, type = "cell_component", mod = mod, assayname = "tpm")
#'
qSVA <-
    function(rse_tx,  type = c("cell_component", "standard", "top1500"),
                      sig_transcripts = NULL,    mod,   assayname) {

      if (is.null(sig_transcripts)) {
        type = arg_match(type) # must be one of those in the list if sig_transcripts is NULL
      }

      # Validate rse_tx is a RangedSummarizedExperiment object
      if (!is(rse_tx, "RangedSummarizedExperiment")) {
        stop("'rse_tx' must be a RangedSummarizedExperiment object.", call. = FALSE)
      }

      # Check if assayname is in assayNames
      if (!assayname %in% assayNames(rse_tx)) {
        stop(sprintf("'%s' is not in assayNames(rse_tx).", assayname), call. = FALSE)
      }

      # Get the qSVs
      DegTx <-
            getDegTx(rse_tx, type = type, sig_transcripts = sig_transcripts, assayname = assayname)
        PCs <- getPCs(DegTx, assayname)
        k <- k_qsvs(DegTx, mod = mod, assayname = assayname)
        qSV <- get_qsvs(PCs, k)
        return(qSV)
    }
