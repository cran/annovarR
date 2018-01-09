## ---- echo = FALSE, message = FALSE--------------------------------------
knitr::opts_chunk$set(comment = "#>", collapse = TRUE)

## ------------------------------------------------------------------------
library(BioInstaller)
library(annovarR)
# Get all BioInstaller supported softwares, databases and files
BioInstaller::install.bioinfo(show.all.names = TRUE)
# Only db_annovar.toml in BioInstaller be included in annovarR
annovarR::download.database(show.all.names = TRUE)

