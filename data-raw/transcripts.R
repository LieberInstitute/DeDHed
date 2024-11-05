library(tidyverse)

#   The top degradation-associated transcripts using each model was already
#   computed in the QSVA_2020 repo at JHPCE; see:
#   https://github.com/LieberInstitute/QSVA_2020/blob/a03958532e653c73a5c075be0afcb13a8cf5eeac/code/03_explore_transcripts/00_explore_transcripts_qsva/04_Modeling_NoVoom.R
jhpce_dir <- "/dcs04/lieber/lcolladotor/qSVA_LIBD3080/degradation_experiments/Joint/all"
transcripts_path <- file.path(
    jhpce_dir, "preprocessed-data", "03_explore_transcripts", "Sig_Txs.RData"
)

#   Grab the top N significant transcripts from the main and interaction models,
#   then take their union
get_top_n <- function(tx_main, tx_int, num_tx) {
    sig_tx_main <- tx_main |>
        rownames_to_column("tx") |>
        as_tibble() |>
        arrange(adj.P.Val) |>
        slice_head(n = num_tx) |>
        pull(tx)

    sig_tx_int <- tx_int |>
        rownames_to_column("tx") |>
        as_tibble() |>
        arrange(adj.P.Val) |>
        slice_head(n = num_tx) |>
        pull(tx)

    return(union(sig_tx_main, sig_tx_int))
}

load(transcripts_path)

transcripts <- list(
    standard = get_top_n(outTxMain, outTxInt, 1000),
    tx1500 = get_top_n(outTxMain, outTxInt, 1500),
    cell_component = union(
        get_top_n(outTxMain, outTxInt, 1000),
        get_top_n(outTxMainSc, outTxIntSc, 1000)
    )
)

usethis::use_data(transcripts, overwrite = TRUE)
