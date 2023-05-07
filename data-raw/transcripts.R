### internal data from the cluster
# setwd("/dcs04/lieber/lcolladotor/qSVA_LIBD3080/degradation_experiments/Joint/all/")

### this script runs on jhpce
library("here")

### standard model
load(here("rdas", "qsvs", "covCombs_withdlpfc.rda"))
covComb_tx_deg_nocc <- covComb_tx_deg
covComb_tx_deg_nocc_down <- covComb_tx_deg_down

## cell component model
load(here("rdas", "qsvs", "covCombs_withdlpfc_cc.rda"))
covComb_tx_deg_cc <- covComb_tx_deg
covComb_tx_deg_cc_down <- covComb_tx_deg_down

## 1500 transcripts model
load(here("rdas", "qsvs", "covCombs_withdlpfc_1500.rda"))

transcripts <- list(tx1500 = rownames(covComb_tx_1500), standard = rownames(covComb_tx_deg_nocc), cell_component = rownames(covComb_tx_deg_cc))


# save(transcripts, file = here("rdas", "qsvs", "model_transcripts.Rda"))

usethis::use_data(transcripts, overwrite = TRUE)
