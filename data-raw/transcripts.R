library(tidyverse)

#   The top degradation-associated transcripts using each model was already
#   computed in the QSVA_2020 repo at JHPCE; see:
#   https://github.com/LieberInstitute/QSVA_2020/blob/a03958532e653c73a5c075be0afcb13a8cf5eeac/code/03_explore_transcripts/00_explore_transcripts_qsva/04_Modeling_NoVoom.R
jhpce_dir <- "/dcs04/lieber/lcolladotor/qSVA_LIBD3080/degradation_experiments/Joint/all"
transcripts_path <- file.path(
    jhpce_dir, "preprocessed-data", "03_explore_transcripts", "Sig_Txs.RData"
)

#   We want to provide as much information from the degradation DE as
#   potentially is useful, but the data is quite large for a Bioc package. To
#   balance these constraints, we'll provide just the top 10,000 significant
#   transcripts and their adjusted p values for each type of degradation model
top_n = 10000

#   Given a data frame of DE results, return the top [top_n] transcripts and
#   their adjusted p values as a tibble
get_top_n = function(tx_df, top_n) {
    tx_df = tx_df |>
        rownames_to_column('tx') |>
        arrange(adj.P.Val) |>
        select(tx, adj.P.Val) |>
        slice_head(n = top_n) |>
        as_tibble()
    
    return(tx_df)
}

load(transcripts_path)

transcripts <- list(
    main_model = get_top_n(outTxMain, top_n),
    int_model = get_top_n(outTxInt, top_n),
    cell_main_model = get_top_n(outTxMainSc, top_n),
    cell_int_model = get_top_n(outTxIntSc, top_n)
)

usethis::use_data(transcripts, overwrite = TRUE)
