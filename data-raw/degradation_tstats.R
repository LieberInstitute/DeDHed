## code to prepare `degradation_tstats` dataset goes here
##

## This code runs at JHPCE
setwd("/dcs04/lieber/lcolladotor/qSVA_LIBD3080/degradation_experiments")

library("here")
load(here("Joint/all/rdas/DE_out/outMainEffect_Tx.Rda"), verbose = TRUE)

degradation_tstats <- outTxMain[, "t", drop = FALSE]
lobstr::obj_size(degradation_tstats) / 1024^2
# 4.128067 MB

saveRDS(degradation_tstats, file = here("Joint/all/rdas/DE_out", "degradation_tstats.rds"))

## Copy to our computer
## scp e:/dcs04/lieber/lcolladotor/qSVA_LIBD3080/degradation_experiments/Joint/all/rdas/DE_out/degradation_tstats.rds .

## This code runs in our computer
degradation_tstats <- readRDS(here::here("data-raw/degradation_tstats.rds"))

usethis::use_data(degradation_tstats, overwrite = TRUE)
## Ok, it's 486.4 Kb on disc which should be ok!

## Next, we need to document the data
# use_r("degradation_tstats-data")
