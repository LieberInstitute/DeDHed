#' Differential expression quality (DEqual) plot
#'
#' A DEqual plot compares the effect of RNA degradation from an independent
#' degradation experiment on the y axis to the effect of the outcome of
#' interest. They were orignally described by Jaffe et al, PNAS, 2017
#' <https://doi.org/10.1073/pnas.1617384114>. Other DEqual versions are
#' included in Collado-Torres et al, Neuron, 2019
#' <https://doi.org/10.1016/j.neuron.2019.05.013>. This function compares your
#' t-statistics of interest computed on transcripts against the
#' t-statistics from degradation time adjusting for the six brain regions from
#' degradation experiment data used for determining `covComb_tx_deg`.
#'
#' @param DE a `data.frame()` with one column containing the t-statistics from
#' Differential Expression, typically generated with `limma::topTable()`.
#' The `rownames(DE)` should be transcript GENCODE IDs.
#'
#' @return a `ggplot` object of the DE t-statistic vs
#' the DE statistic from degradation
#' @import ggplot2
#' @import tidyverse
#' @importFrom stats cor
#' @export
#'
#' @examples
#'
#' ## Random differential expression t-statistics for the same transcripts
#' ## we have degradation t-statistics for in `degradation_tstats`.
#' set.seed(101)
#' random_de <- data.frame(
#'     t = rt(nrow(degradation_tstats), 5),
#'     row.names = sample(
#'         rownames(degradation_tstats),
#'         nrow(degradation_tstats)
#'     )
#' )
#'
#' ## Create the DEqual plot
#' DEqual(random_de)
DEqual <- function(DE) {
    ## For R CMD check
    DE_t <- degradation_t <- NULL

    ## Check input
    # stopifnot("t" %in% colnames(DE))
    # stopifnot(!is.null(rownames(DE)))

    # Check if 't' is in the column names of DE
      if (!("t" %in% colnames(DE))) {
        stop("Error: 't' is not a column in DE.")
      }
    
    # Check if DE has non-null row names
      if (is.null(rownames(DE))) {
        stop("Error: Row names of DE are null.")
      }
    
    ## Locate common transcripts
    common <- intersect(rownames(qsvaR::degradation_tstats), rownames(DE))
    #stopifnot(length(common) > 0)
    
    # Check if the length of 'common' is greater than 0
    if (length(common) <= 0) {
      stop("Error: The length of 'common' should be greater than 0.")
    }
    
    ## Create dataframe with common transcripts
    common_data <- data.frame(
        degradation_t = qsvaR::degradation_tstats$t[match(common, rownames(qsvaR::degradation_tstats))],
        DE_t = DE$t[match(common, rownames(DE))]
    )
    p <- ggplot(common_data, aes(x = DE_t, y = degradation_t)) +
        xlab("DE t-statistic") +
        ylab("Degradation t-statistic") +
        geom_bin2d(bins = 70) +
        scale_fill_continuous(type = "viridis") +
        theme_bw() +
        labs(caption = paste0("correlation: ", signif(cor(common_data[, 1], common_data[, 2]), 2)))
    return(p)
}
