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
#' degradation experiment data used for determining `rse_tx`.
#'
#' @param DE a `data.frame()` with a column "t" containing the t-statistics
#' from Differential Expression, typically generated with `limma::topTable()`.
#' `rownames(DE)` must have transcript Ensembl/Gencode IDs.
#' @param deg_tstats an optional`data.frame()` with a column "t" containing
#' t-statistics resulted from a degradation experiment. Default is the
#' internal `qsvaR::degradation_tstats` from the package authors.
#' @param show.legend logical (default TRUE) to show legend in the plot
#' @param show.cor specify where to show the correlation value. Can be one of
#' "caption", "corner-top", "corner-bottom", or "none".
#' @param font.size numeric value to set the base font size of the plot
#' @param cor.size numeric (default font.size/2) to set the font size for the
#' correlation text
#' @param cor.label character (default "cor: ") to set the text preceding the
#'  correlation value
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
DEqual <- function(DE, deg_tstats = qsvaR::degradation_tstats, show.legend = TRUE,
                        show.cor = c('caption','corner-top','corner-bottom','none'),
                        font.size = 12,  cor.size = font.size/2, cor.label = 'cor: ') {
    ## For R CMD check
    DE_t <- degradation_t <- NULL
    show.cor=rlang::arg_match(show.cor)
    ## Check input
    if (!is.data.frame(DE)) {
      stop("The input to DEqual is not a dataframe.", call. = FALSE)
      }
    # Check if 't' is in the column names of DE
    if (!("t" %in% colnames(DE))) {
        stop("'t' is not a column in 'DE'.", call. = FALSE)
      }
    # Check if DE has non-null row names
    if (is.null(rownames(DE))) {
        stop("Row names of 'DE' are NULL.", call. = FALSE)
    }
    if (!missing(deg_tstats)) {
        if (!is.data.frame(deg_tstats)) {
            stop("The 'deg_tstats' parameter is not a dataframe.", call. = FALSE)
        }
        if (!("t" %in% colnames(deg_tstats))) {
            stop("'t' is not a column in 'deg_tstats'.", call. = FALSE)
        }
        if (is.null(rownames(deg_tstats))) {
            stop("Row names of 'deg_tstats' are NULL.", call. = FALSE)
        }
        if (!all(grepl("^ENST\\d+", rownames(deg_tstats)))) {
            stop("The row names of 'deg_tstats' must be ENSEMBL or Gencode IDs (ENST...)", call. = FALSE)
        }
    }

    ## Locate common transcripts
    whichTx <- which_tx_names(rownames(DE),rownames(deg_tstats))
    common = qsvaR::normalize_tx_names(rownames(DE)[whichTx])
    stopifnot(length(common) > 0)
    rownames(deg_tstats) <- qsvaR::normalize_tx_names(rownames(deg_tstats))
    ## Create dataframe with common transcripts
    common_data <- data.frame(
        degradation_t = deg_tstats[common, "t"],
        DE_t = DE[whichTx, "t"]
    )
    cor_val <- signif(cor(common_data[, 1], common_data[, 2]), 2)
    p <- ggplot(common_data, aes(x = DE_t, y = degradation_t)) +
        xlab("DE t-statistic") +
        ylab("Degradation t-statistic") +
        geom_bin2d(bins = 70, show.legend = show.legend) +
        scale_fill_continuous(type = "viridis") +
        theme_bw() +
        theme(text = element_text(size = font.size))
        # labs(caption = paste0("correlation: ", cor_val)
    if (show.cor != 'none') {
      switch(show.cor,
        'caption' = {
          p <- p + labs(caption = paste0(cor.label, cor_val))
        },
        'corner-top' = {
          p <- p + annotate("text", x = max(common_data$DE_t), y = max(common_data$degradation_t),
                            label = paste0(cor.label, cor_val), size = cor.size, hjust = 1, vjust = 1)
        },
        'corner-bottom' = {
          p <- p + annotate("text", x = max(common_data$DE_t), y = min(common_data$degradation_t),
                            label = paste0(cor.label, cor_val), size = cor.size, hjust = 1, vjust = 0)
        })
    }
    return(p)
}
