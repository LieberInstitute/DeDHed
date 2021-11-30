## code to prepare `covComb_tx_deg` dataset goes here

##change to jhpce path
load("data/covComb_tx_deg.rda")

usethis::use_data(covComb_tx_deg, overwrite = TRUE)
