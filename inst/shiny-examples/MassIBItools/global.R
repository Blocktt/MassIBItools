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
library(MIEGLEtools)
library(leaflet)
# library(plotly)
library(shinyjs) # used for download button enable


# Drop-down boxes
MMIs <- c("MIEGLE_2020")
Community <- c("bugs")


# File Size
# By default, the file size limit is 5MB. It can be changed by
# setting this option. Here we'll raise limit to 10MB.
options(shiny.maxRequestSize = 25*1024^2)

# source function from metric.values.MI.R
source(file.path(".", "external", "metric.values.MA.R"))


# define which metrics michigan wants to keep in indices

MichMetrics <- c("nt_CruMol"
                 ,"pi_ffg_pred"
                 ,"pi_ffg_shred"
                 ,"pi_habit_cling"
                 ,"pi_CruMol"
                 ,"nt_tv_toler"
                 ,"pt_NonIns"
                 ,"pi_habit_climb"
                 ,"pi_EPT"
                 ,"pi_EPTNoBaeHydro"
                 ,"pi_tv_toler"
                 ,"nt_EPT"
                 ,"pi_Cru"
                 ,"pt_tv_intol"
                 ,"nt_NonIns"
                 ,"pi_ffg_scrap"
                 ,"pi_IsopGastHiru"
                 ,"pi_NonIns"
                 ,"pi_Pleco"
                 ,"pt_tv_toler"
                 ,"pi_ffg_col"
                 ,"pi_habit_sprawl"
                 ,"nt_Trich"
                 ,"nt_habit_cling"
                 ,"pi_tv_intol"
)# END MichMetricss


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

