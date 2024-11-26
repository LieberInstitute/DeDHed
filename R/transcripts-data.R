#' Transcripts for Degradation Models
#'
#' This object is a list of four `tibble`s where each element corresponds to the
#' top 10,000 transcripts (by significance) and their adjusted p-values for a
#' given degradation model. The `main_model` model is a linear model modelling
#' expression against a sample's degradation time, with brain region as a
#' covariate. The `int_model` model is similar but includes an interaction term
#' with degradation time and brain region. The `cell_main_model` and
#' `cell_int_model` models are like the respective `main_model` and `int_model`
#' models, but including cell-type fractions from deconvolution as linear terms.
#' @name transcripts
#' @docType data
#' @format A `list()` of `tibble()`s containing the transcripts and adjusted
#' p-values selected by each model.
#' Each string is a GENCODE transcript IDs.
#' @keywords datasets
#' @seealso [select_transcripts]
"transcripts"
