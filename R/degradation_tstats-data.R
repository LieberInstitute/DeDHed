#' Degradation time t-statistics
#'
#' These t-statistics are derived from the degradation timepoints data
#' built into qsvaR. They are the results from multiple models where
#' we determined the association of transcripts with degradation time
#' adjusting for brain region (so parallel degradation effects across
#' brain regions). They are used for plotting in `DEqual()`.
#'
#' @name degradation_tstats
#' @docType data
#' @format A `data.frame()` with the `t` statistics for degradation time. The
#' `rownames()` are the GENCODE transcript IDs.
#' @keywords datasets
#' @seealso [DEqual]
NULL
