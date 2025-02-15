% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/degradation_tstats-data.R
\docType{data}
\name{degradation_tstats}
\alias{degradation_tstats}
\title{Degradation time t-statistics}
\format{
A \code{data.frame()} with the \code{t} statistics for degradation time. The
\code{rownames()} are the GENCODE transcript IDs.
}
\description{
These t-statistics are derived from the degradation timepoints data
built into qsvaR. They are the results from multiple models where
we determined the association of transcripts with degradation time
adjusting for brain region (so parallel degradation effects across
brain regions). They are used for plotting in \code{DEqual()}.
}
\seealso{
\link{DEqual}
}
\keyword{datasets}
