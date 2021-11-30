## code to prepare `DATASET` dataset goes here
load("data/covComb_tx_deg.rda")

usethis::use_data(covComb_tx_deg, overwrite = TRUE)
