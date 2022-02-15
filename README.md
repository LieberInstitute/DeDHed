
<!-- README.md is generated from README.Rmd. Please edit that file -->

# qsvaR

<!-- badges: start -->
<!-- badges: end -->

The goal of qsvaR is to provide software that can remove the effects of
bench degradation from RNA-seq data.

## Installation Instructions

Get the latest stable R release from CRAN. Then install DeconvoBuddies
using from Bioconductor the following code:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("DeconvoBuddies")
```

And the development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("LieberInstitute/qsvaR")
```

## Example

This is a basic example which shows you how to obtain the qsvs for a
dataset:

``` r
library(qsvaR)
#> Loading required package: SummarizedExperiment
#> Loading required package: MatrixGenerics
#> Loading required package: matrixStats
#> 
#> Attaching package: 'MatrixGenerics'
#> The following objects are masked from 'package:matrixStats':
#> 
#>     colAlls, colAnyNAs, colAnys, colAvgsPerRowSet, colCollapse,
#>     colCounts, colCummaxs, colCummins, colCumprods, colCumsums,
#>     colDiffs, colIQRDiffs, colIQRs, colLogSumExps, colMadDiffs,
#>     colMads, colMaxs, colMeans2, colMedians, colMins, colOrderStats,
#>     colProds, colQuantiles, colRanges, colRanks, colSdDiffs, colSds,
#>     colSums2, colTabulates, colVarDiffs, colVars, colWeightedMads,
#>     colWeightedMeans, colWeightedMedians, colWeightedSds,
#>     colWeightedVars, rowAlls, rowAnyNAs, rowAnys, rowAvgsPerColSet,
#>     rowCollapse, rowCounts, rowCummaxs, rowCummins, rowCumprods,
#>     rowCumsums, rowDiffs, rowIQRDiffs, rowIQRs, rowLogSumExps,
#>     rowMadDiffs, rowMads, rowMaxs, rowMeans2, rowMedians, rowMins,
#>     rowOrderStats, rowProds, rowQuantiles, rowRanges, rowRanks,
#>     rowSdDiffs, rowSds, rowSums2, rowTabulates, rowVarDiffs, rowVars,
#>     rowWeightedMads, rowWeightedMeans, rowWeightedMedians,
#>     rowWeightedSds, rowWeightedVars
#> Loading required package: GenomicRanges
#> Loading required package: stats4
#> Loading required package: BiocGenerics
#> Loading required package: parallel
#> 
#> Attaching package: 'BiocGenerics'
#> The following objects are masked from 'package:parallel':
#> 
#>     clusterApply, clusterApplyLB, clusterCall, clusterEvalQ,
#>     clusterExport, clusterMap, parApply, parCapply, parLapply,
#>     parLapplyLB, parRapply, parSapply, parSapplyLB
#> The following objects are masked from 'package:stats':
#> 
#>     IQR, mad, sd, var, xtabs
#> The following objects are masked from 'package:base':
#> 
#>     anyDuplicated, append, as.data.frame, basename, cbind, colnames,
#>     dirname, do.call, duplicated, eval, evalq, Filter, Find, get, grep,
#>     grepl, intersect, is.unsorted, lapply, Map, mapply, match, mget,
#>     order, paste, pmax, pmax.int, pmin, pmin.int, Position, rank,
#>     rbind, Reduce, rownames, sapply, setdiff, sort, table, tapply,
#>     union, unique, unsplit, which.max, which.min
#> Loading required package: S4Vectors
#> 
#> Attaching package: 'S4Vectors'
#> The following objects are masked from 'package:base':
#> 
#>     expand.grid, I, unname
#> Loading required package: IRanges
#> Loading required package: GenomeInfoDb
#> Loading required package: Biobase
#> Welcome to Bioconductor
#> 
#>     Vignettes contain introductory material; view with
#>     'browseVignettes()'. To cite Bioconductor, see
#>     'citation("Biobase")', and for packages 'citation("pkgname")'.
#> 
#> Attaching package: 'Biobase'
#> The following object is masked from 'package:MatrixGenerics':
#> 
#>     rowMedians
#> The following objects are masked from 'package:matrixStats':
#> 
#>     anyMissing, rowMedians
## basic example data
bfc <- BiocFileCache::BiocFileCache()
rse_file <- BiocFileCache::bfcrpath("https://s3.us-east-2.amazonaws.com/libd-brainseq2/rse_tx_unfiltered.Rdata", x = bfc)
load(rse_file,verbose = TRUE)
#> Loading objects:
#>   rse_tx

##get degraded transcripts for qsva
DegTx<-getDegTx(rse_tx,rownames(covComb_tx_deg))

#get pcs of degraded
pcTx<-getPCs(DegTx, "tpm")

#use a simple model and our get K function to determine the number of pcs needed
mod <-model.matrix(~ Dx + Age +Sex + Race + Region,
    data = colData(rse_tx))
k<-k_qsvs(DegTx,mod, "tpm")
print(k)
#> [1] 34
```

Now that we have our pcs and the number we need we can generate our qsvs

``` r
qsvs<-get_qsvs(pcTx, k)
dim(qsvs)
#> [1] 900  34
```

What is special about using `README.Rmd` instead of just `README.md`?
You can include R chunks like so:

\#\#\#Differential Expression Next we can use a standard limma package
approach to do differential expression on the data. The key here is that
we add our qsvs to the model.matrix.

``` r
    library(limma)
#> 
#> Attaching package: 'limma'
#> The following object is masked from 'package:BiocGenerics':
#> 
#>     plotMA
    pd<-colData(rse_tx)
    pd<-cbind(qsvs,pd)
    mod <-model.matrix(~ Dx + Age + Sex + Race + Region + pd$PC1 +pd$PC2+ pd$PC3 +pd$PC4+ pd$PC5 +pd$PC6+ pd$PC7 +pd$PC8+ pd$PC9 +pd$PC10+ pd$PC11 +pd$PC12+ pd$PC13 +pd$PC14+ pd$PC15 +pd$PC16 + pd$PC17 +pd$PC18+ pd$PC19 +pd$PC20+ pd$PC21 +pd$PC22+ pd$PC23 +pd$PC24+ pd$PC25 +pd$PC26+ pd$PC27 +pd$PC28+ pd$PC29 +pd$PC30+ pd$PC31, data = colData(rse_tx))
    txExprs <- log2(assays(rse_tx)$tpm + 1)
    fitTx <- lmFit(txExprs, mod)
    eBTx <- eBayes(fitTx)
#> Warning: Zero sample variances detected, have been offset away from zero
    sigTx <- topTable(eBTx,
    coef = 2,
    p.value = 1, number = nrow(rse_tx)
)
    head(sigTx)
#>                         logFC    AveExpr         t      P.Value   adj.P.Val
#> ENST00000552074.5 -0.13720275 2.43479854 -5.689845 1.741938e-08 0.003393897
#> ENST00000553142.5 -0.06152815 2.03908885 -5.568843 3.426570e-08 0.003393897
#> ENST00000530589.1 -0.10860387 2.42717114 -5.173338 2.861319e-07 0.018893579
#> ENST00000527986.5  0.07979267 2.75115185  5.069278 4.888453e-07 0.019568383
#> ENST00000450454.6  0.09037372 1.00424397  5.067253 4.939191e-07 0.019568383
#> ENST00000578387.1  0.01564682 0.07057326  4.986614 7.430097e-07 0.021627801
#>                          B
#> ENST00000552074.5 8.466651
#> ENST00000553142.5 7.811476
#> ENST00000530589.1 5.761766
#> ENST00000527986.5 5.246010
#> ENST00000450454.6 5.236073
#> ENST00000578387.1 4.843337
```
