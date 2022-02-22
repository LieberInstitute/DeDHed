#' Title
#'
#' @param DE data.frame with one column of the t-statistic from Differential Expression. The row names are the transcripts names
#'
#' @return a ggplot object of the DE t-statistc vs the DE statistic from degradation
#' @export
#'
#' @examples
#' TODO
DEqual <- function(DE) {
    data <- cbind(deg$t, DE$t)
    p <- ggplot(data, aes(x = V2, y = V1)) +
        xlab("DE statistic") +
        eBTx_qsva <- eBayes(fitTx_qsva)
    ylab("Degradation statistic") +
        geom_bin2d(bins = 70) +
        scale_fill_continuous(type = "viridis") +
        theme_bw()
    return(p)
}
