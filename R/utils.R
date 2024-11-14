#' Remove version number from Gencode/Ensembl IDs
#'
#' This function removes the version from the Gencode/ENSEMBL IDs, while protecting _PAR_Y suffixes if present
#'
#' @param fids A `character()` vector of GENCODE or ENSEMBL feature IDs
#'
#'
#' @return A
#'  `character()` vector of feature IDs without versioning
#'
#' @export
#'
#' @examples
#' ensIDs <- normalize_feature_ids(rownames(rse))
normalize_feature_ids <- function(fids) {
    sub("(ENS[TG]\\d+)\\.\\d+(.*)$", "\\1\\2", fids, perl = TRUE)
}


#' Check validity of feature vectors and return a vector matching indexes in f1
#'
#' This function is used to check if fids and sig_ids are GENCODE/ENSEMBL IDs
#' and return an integer vector of fids feature indexes that are in sig_ids.
#'
#' @param fids A `character()` vector of GENCODE or ENSEMBL feature IDs.
#' @param sig_ids A `character()` vector of GENCODE or ENSEMBL signature feature IDs.
#'
#'
#' @return A
#'  `integer()` vector of `fids` feature indexes in `sig_ids`.
#'
#' @export
#'
#' @examples
#' sig_ids <- select_features("cell_component")
#' whichIDs <- which_feature_ids(rownames(rse), sig_ids)
which_feature_ids <- function(fids, sig_ids) {
    ## Between releases 25 and 43, PAR genes and transcripts had the "_PAR_Y" suffix appended to their identifiers.
    ## Since release 44, these have their own IDs
    if (!all(grepl("^ENS[TG]\\d+", fids))) {
        stop("The feature IDs must be ENSEMBL or Gencode IDs (ENS[TG]...)")
    }
    if (!all(grepl("^ENS[TG]\\d+", sig_ids))) {
        stop("The signature feature IDs must be ENSEMBL or Gencode IDs (ENS[TG]...)")
    }
    ## normalize the feature IDs
    r_ids <- normalize_feature_ids(fids)
    s_ids <- normalize_feature_ids(sig_ids)
    which(r_ids %in% s_ids)
}
