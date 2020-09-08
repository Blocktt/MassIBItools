# metric.values, Michigan EGLE IBI ####
test_that("metric.values, Michigan EGLE IBI", {
  SAMPLEID <- c(rep("010066-9/13/12", 45))
  INDEX_NAME <- "MIEGLE_2020"
  INDEX_REGION <- c(rep("Narrow", 45))
  TAXAID <- c("Elmidae"
              ,"Hydrophilidae"
              ,"Gyrinidae"
              ,"Uenoidae"
              ,"Phryganeidae"
              ,"Molannidae"
              ,"Limnephilidae"
              ,"Psephenidae"
              ,"Hydropsychidae"
              ,"Ancylidae"
              ,"Leptoceridae"
              ,"Athericidae"
              ,"Ceratopogonidae"
              ,"Chironomidae"
              ,"Culicidae"
              ,"Simuliidae"
              ,"Tipulidae"
              ,"Physidae"
              ,"Planorbidae"
              ,"Sphaeriidae"
              ,"Gerridae"
              ,"Helicopsychidae"
              ,"Tabanidae"
              ,"Hydracarina"
              ,"Notonectidae"
              ,"Oligochaeta"
              ,"Isopoda"
              ,"Baetiscidae"
              ,"Baetidae"
              ,"Ephemerellidae"
              ,"Heptageniidae"
              ,"Leptophlebiidae"
              ,"Tricorythidae"
              ,"Aeshnidae"
              ,"Turbellaria"
              ,"Amphipoda"
              ,'Gomphidae'
              ,"Sialidae"
              ,"Corydalidae"
              ,"Mesoveliidae"
              ,"Glossosomatidae"
              ,"Corixidae"
              ,"Belostomatidae"
              ,"Perlidae"
              ,"Calopterygidae")


  N_TAXA <- c(59
              ,1
              ,1
              ,5
              ,4
              ,1
              ,10
              ,1
              ,11
              ,2
              ,22
              ,7
              ,2
              ,10
              ,1
              ,4
              ,1
              ,18
              ,1
              ,12
              ,1
              ,35
              ,4
              ,1
              ,1
              ,7
              ,2
              ,8
              ,16
              ,24
              ,12
              ,3
              ,8
              ,1
              ,9
              ,2
              ,1
              ,1
              ,1
              ,5
              ,1
              ,2
              ,1
              ,1
              ,21)

  TOLVAL <- c(4
              ,5.4
              ,4.1
              ,1.5
              ,4.5
              ,5.2
              ,2.8
              ,3.9
              ,2.7
              ,6.7
              ,3.6
              ,2
              ,6.3
              ,5.5
              ,8.1
              ,4.2
              ,4
              ,8
              ,6.5
              ,6.6
              ,5.7
              ,2
              ,6.3
              ,5.5
              ,8.6
              ,NA
              ,7.6
              ,3.3
              ,4.6
              ,2.2
              ,1.9
              ,2.3
              ,NA
              ,5.7
              ,NA
              ,6.2
              ,4
              ,5.1
              ,4.9
              ,NA
              ,0.6
              ,8.2
              ,9.9
              ,1.8
              ,6.1)
  PHYLUM <- c("Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Mollusca"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Mollusca"
              ,"Mollusca"
              ,"Mollusca"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Annelida"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Platyhelminthes"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda"
              ,"Arthropoda")
  SUBPHYLUM <- c(NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,"Crustacea"
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,"Crustacea"
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA
                 ,NA)
  CLASS <- c("Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Gastropoda"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Gastropoda"
             ,"Gastropoda"
             ,"Bivalvia"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Arachnida"
             ,"Insecta"
             ,"Oligochaeta"
             ,"Crustacea"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Turbellaria"
             ,"Crustacea"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta"
             ,"Insecta")
  ORDER <- c("Coleoptera"
             ,"Coleoptera"
             ,"Coleoptera"
             ,"Trichoptera"
             ,"Trichoptera"
             ,"Trichoptera"
             ,"Trichoptera"
             ,"Coleoptera"
             ,"Trichoptera"
             ,"Basommatophora"
             ,"Trichoptera"
             ,"Diptera"
             ,"Diptera"
             ,"Diptera"
             ,"Diptera"
             ,"Diptera"
             ,"Diptera"
             ,"Basommatophora"
             ,"Basommatophora"
             ,"Veneroida"
             ,"Hemiptera"
             ,"Trichoptera"
             ,"Diptera"
             ,NA
             ,"Hemiptera"
             ,"Haplotaxida"
             ,"Isopoda"
             ,"Ephemeroptera"
             ,"Ephemeroptera"
             ,"Ephemeroptera"
             ,"Ephemeroptera"
             ,"Ephemeroptera"
             ,"Ephemeroptera"
             ,"Odonata"
             ,NA
             ,"Amphipoda"
             ,"Odonata"
             ,"Megaloptera"
             ,"Megaloptera"
             ,"Hemiptera"
             ,"Trichoptera"
             ,"Hemiptera"
             ,"Hemiptera"
             ,"Plecoptera"
             ,"Odonata")

  FAMILY <- c("Elmidae"
              ,"Hydrophilidae"
              ,"Gyrinidae"
              ,"Uenoidae"
              ,"Phryganeidae"
              ,"Molannidae"
              ,"Limnephilidae"
              ,"Psephenidae"
              ,"Hydropsychidae"
              ,"Ancylidae"
              ,"Leptoceridae"
              ,"Athericidae"
              ,"Ceratopogonidae"
              ,"Chironomidae"
              ,"Culicidae"
              ,"Simulidae"
              ,"Tipulidae"
              ,"Physidae"
              ,"Planorbidae"
              ,"Sphaeriidae"
              ,"Gerridae"
              ,"Helicopsychidae"
              ,"Tabanidae"
              ,NA
              ,"Notonectidae"
              ,NA
              ,NA
              ,"Baetiscidae"
              ,"Baetidae"
              ,"Ephemerellidae"
              ,"Heptageniidae"
              ,"Leptophlebiidae"
              ,"Tricorythidae"
              ,"Aeshnidae"
              ,NA
              ,NA
              ,"Gomphidae"
              ,"Sialidae"
              ,"Corydalidae"
              ,"Mesoveliidae"
              ,"Glossosomatidae"
              ,"Corixidae"
              ,"Belostomatidae"
              ,"Perlidae"
              ,"Calopterygidae")
  FFG <- c("CG"
           ,"PR"
           ,"PR"
           ,"SC"
           ,"SH"
           ,"SC"
           ,"SH"
           ,"SC"
           ,"CF"
           ,"SC"
           ,"SH"
           ,"PR"
           ,"PR"
           ,"CG"
           ,"CF"
           ,"CF"
           ,"CG"
           ,"SC"
           ,"SC"
           ,"CF"
           ,"PR"
           ,"SC"
           ,"PR"
           ,"PR"
           ,"PR"
           ,"CG"
           ,"SH"
           ,"CG"
           ,"CG"
           ,"SC"
           ,"SC"
           ,"CG"
           ,"CG"
           ,"PR"
           ,"CG"
           ,"SH"
           ,"PR"
           ,"PR"
           ,"PR"
           ,"PR"
           ,"SC"
           ,"CG"
           ,"PR"
           ,"PR"
           ,"PR")

  HABIT <- c("CN"
             ,"BU, SW"
             ,"SW"
             ,"CN"
             ,"CB, CN"
             ,"SP"
             ,"SP"
             ,"CN"
             ,"CN"
             ,"CB, CN"
             ,"SP, SW"
             ,"SP"
             ,"BU, SP"
             ,NA
             ,"SW"
             ,"CN"
             ,"BU"
             ,"CB"
             ,"CB"
             ,NA
             ,"SK"
             ,"BU"
             ,"SP"
             ,NA
             ,"SW"
             ,"BU"
             ,NA
             ,"BU, CN, SP"
             ,"CN, SW"
             ,"CN"
             ,"CN"
             ,"CN, SW"
             ,NA
             ,"CB, CN"
             ,NA
             ,NA
             ,"BU"
             ,"BU"
             ,"CN"
             ,"SK"
             ,"CN"
             ,"SW"
             ,"CB, SW"
             ,"CN"
             ,"CB, CN")


  EXCLUDE <- rep(FALSE, 45)
  df_bugs <- data.frame(SAMPLEID, INDEX_NAME, INDEX_REGION
                        , TAXAID, N_TAXA, TOLVAL, ORDER
                        , PHYLUM, SUBPHYLUM, CLASS, FAMILY, FFG, HABIT, EXCLUDE)

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



  # metric values
  df_metval <- suppressMessages(suppressWarnings(BioMonTools::metric.values(df_bugs, "bugs", fun.MetricNames = MichMetrics , boo.Shiny = TRUE)))
  #1

  # df, calc

  col_qc <- c("SAMPLEID"
              ,"INDEX_REGION"
              ,"INDEX_NAME"
              ,"ni_total"
              ,"nt_CruMol"
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
              ,"pi_tv_intol")


  df_metval_calc <- df_metval[, col_qc]
  # Round values to 1 or 2 digits
  df_metval_calc[,4:ncol(df_metval_calc)] <- round(df_metval_calc[,4:ncol(df_metval_calc)],1)

  # df, QC
  SAMPLEID <- "010066-9/13/12"
  INDEX_NAME <- "MIEGLE_2020"
  INDEX_REGION <- "NARROW"
  ni_total <- 341
  nt_CruMol <-6
  pi_ffg_pred <-14.7
  pi_ffg_shred <-11.7
  pi_habit_cling <-51
  pi_CruMol <-10.9
  nt_tv_toler <-6
  pt_NonIns <-20
  pi_habit_climb <-14.1
  pi_EPT <-47.2
  pi_EPTNoBaeHydro <-39.3
  pi_tv_toler <-7.3
  nt_EPT <-15
  pi_Cru <-1.2
  pt_tv_intol <-22.2
  nt_NonIns <-9
  pi_ffg_scrap <-29.3
  pi_IsopGastHiru <-6.7
  pi_NonIns <-15.8
  pi_Pleco <-0.3
  pt_tv_toler <-13.3
  pi_ffg_col <-36.1
  pi_habit_sprawl <-15.8
  nt_Trich <-8
  nt_habit_cling <-17
  pi_tv_intol <-32


  df_metval_calc$INDEX_REGION <- as.factor(df_metval_calc$INDEX_REGION)


  df_metval_qc <- data.frame(SAMPLEID
                             ,INDEX_REGION
                             ,INDEX_NAME
                             ,ni_total
                             ,nt_CruMol
                             ,pi_ffg_pred
                             ,pi_ffg_shred
                             ,pi_habit_cling
                             ,pi_CruMol
                             ,nt_tv_toler
                             ,pt_NonIns
                             ,pi_habit_climb
                             ,pi_EPT
                             ,pi_EPTNoBaeHydro
                             ,pi_tv_toler
                             ,nt_EPT
                             ,pi_Cru
                             ,pt_tv_intol
                             ,nt_NonIns
                             ,pi_ffg_scrap
                             ,pi_IsopGastHiru
                             ,pi_NonIns
                             ,pi_Pleco
                             ,pt_tv_toler
                             ,pi_ffg_col
                             ,pi_habit_sprawl
                             ,nt_Trich
                             ,nt_habit_cling
                             ,pi_tv_intol)

  # test
  testthat::expect_equal(df_metval_calc, df_metval_qc)



  # Metric.Scores

  library(readxl)


  # Thresholds
  fn_thresh <- file.path(system.file(package="BioMonTools"), "extdata", "MetricScoring.xlsx")
  df_thresh_metric <- read_excel(fn_thresh, sheet="metric.scoring")
  df_thresh_index <- read_excel(fn_thresh, sheet="index.scoring")

  # run scoring code
  df_metsc <- metric.scores(DF_Metrics = df_metval_calc, col_MetricNames = MichMetrics,
                            col_IndexName = "INDEX_NAME", col_IndexRegion = "INDEX_REGION",
                            DF_Thresh_Metric = df_thresh_metric, DF_Thresh_Index = df_thresh_index,
                            col_ni_total = "ni_total")

  df_metsc_calc <- df_metsc[,colSums(is.na(df_metsc))<nrow(df_metsc)]


  # For report all numbers rounded
  df_metsc_calc[, 4:36] <- round(df_metsc_calc[, 4:36], 1)

  # df_QC
  df_metsc_qc <- df_metval_qc
  df_metsc_qc$SC_pi_ffg_shred <-80.1
  df_metsc_qc$SC_pt_NonIns <-54.8
  df_metsc_qc$SC_pi_habit_climb <-24.2
  df_metsc_qc$SC_pi_EPT <-55.7
  df_metsc_qc$SC_pi_tv_toler <-59.8
  df_metsc_qc$sum_Index    <- rowSums(df_metsc_qc[, 30:34])
  df_metsc_qc$Index        <- 54.9
  df_metsc_qc$Index_Nar    <- "High Moderate 50-75"



  df_metsc_calc$INDEX_REGION <- as.factor(df_metsc_calc$INDEX_REGION)



  # test
  testthat::expect_equal(df_metsc_calc, df_metsc_qc)


  x <- sum(df_metsc_calc == df_metsc_qc, na.rm = TRUE)
  y <- sum(!is.na(df_metsc_qc))
  testthat::expect_equal(x, y)

})## Test - Michigan EGLE IBI ~ END
