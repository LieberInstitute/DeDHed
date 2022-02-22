#' DEqual plot
#'
#' TODO description. Maybe include links to published versions of this plot.
#'
#' @param DE a `data.frame()` with one column containing the t-statistics from
#' Differential Expression, typically generated with `limma::topTable()`.
#' The `rownames(DE)` should be transcript GENCODE IDs.
#'
#' @return a `ggplot` object of the DE t-statistic vs the DE statistic from degradation
#' @import ggplot2
#' @export
#'
#' @examples
#'
#' ## Random differential expression t-statistics for the same transcripts
#' ## we have degradation t-statistics for in `degradation_tstats`.
#' set.seed(101)
#' random_de <- data.frame(
#'     t = rt(nrow(degradation_tstats), 5),
#'     row.names = sample(rownames(degradation_tstats), nrow(degradation_tstats))
#' )
#'
#' ## Create the DEqual plot
#' DEqual(random_de)
DEqual <- function(DE) {
    ## Check input
    stopifnot("t" %in% colnames(DE))
    stopifnot(!is.null(rownames(DE)))

    ## Locate common transcripts
    common <- intersect(rownames(degradation_tstats), rownames(DE))
    stopifnot(length(common) > 0)
    common_data <- data.frame(
        degradation_t = degradation_tstats$t[match(common, rownames(degradation_tstats))],
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
