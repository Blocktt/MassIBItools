# Shiny Global File

# Packages
library(shiny)
library(DT)
library(ggplot2)
library(readxl)
library(reshape2)
library(dplyr)
library(utils)
library(BioMonTools)
library(knitr)
library(maps)
library(rmarkdown)
library(tidyr)
library(MassIBItools)
library(leaflet)
# library(plotly)
library(shinyjs) # used for download button enable


# Drop-down boxes
MMIs <- c("MassDEP_Kick_2019")
Community <- c("bugs")


# File Size
# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 10MB.
options(shiny.maxRequestSize = 25*1024^2)

# source function from metric.values.MI.R
source(file.path(".", "external", "metric.values.MA.R"))


# define which metrics michigan wants to keep in indices

MassMetrics <- c("nt_total"
                 ,"pt_EPT"
                 ,"pi_EphemNoCaeBae"
                 ,"pi_ffg_filt"
                 ,"pt_ffg_pred"
                 ,"pt_tv_intol"
                 ,"pi_Pleco"
                 ,"pi_ffg_shred"
                 ,"pi_tv_intol"
                 ,"x_Becks"

)# END MassMetricss


# https://stackoverflow.com/questions/51292957/is-there-a-way-to-open-a-users-vignette-in-a-shiny-link
# Function to get link to a package Vignette
# get_vignette_link <- function(...) {
#   x <- vignette(...)
#   if (nzchar(out <- x$PDF)) {
#     ext <- tools::file_ext(out)
#     port <- if (tolower(ext) == "html")
#       tools::startDynamicHelp(NA)
#     else 0L
#     if (port > 0L) {
#       out <- sprintf("http://127.0.0.1:%d/library/%s/doc/%s",
#                      port, basename(x$Dir), out)
#       return(out)
#     }
#   }
#   stop("no html help found")
# }

