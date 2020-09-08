#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Packages
# library(shiny)
# library(DT)
# library(ggplot2)
# library(readxl)
# library(reshape2)
# library(dplyr)
# library(utils)
# library(BioMonTools)
# library(knitr)
# library(maps)
# library(rmarkdown)
# library(tidyr)
# # library(plotly)
# library(shinyjs) # used for download button enable

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    # map test
    map_data <- reactiveValues(df_metsc = NULL)

    # Testing ####
    #runcodeServer() # for Testing

    # Misc Names ####
    output$fn_input_display <- renderText({input$fn_input})


    # output$vig <- renderUI({
    #   # a("MBSStools vignette",
    #   #   href=get_vignette_link("MBSStools_vignette", package="MBSStools"))
    #   #includeHTML(file.path(".", "www", "MBSStools_vignette.html"))
    #   a("MBSStools vignette",
    #     href=file.path(".", "www", "MBSStools_vignette.html"))
    # })


    # df_import ####
    output$df_import_DT <- renderDT({
        # input$df_import will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.

        inFile <- input$fn_input

        shiny::validate(
            need(inFile != "", "Please select a data set") # used to inform the user that a data set is required
        )

        if (is.null(inFile)){
            return(NULL)
        }##IF~is.null~END

        # Read user imported file
        df_input <- read.csv(inFile$datapath, header = input$header,
                             sep = input$sep, quote = input$quote, stringsAsFactors = FALSE)

        required_columns <- c("INDEX_NAME"
                              ,"SAMPLEID"
                              ,"LAT"
                              ,"LONG"
                              ,"INDEX_REGION"
                              ,"TAXAID"
                              ,"N_TAXA"
                              ,"EXCLUDE"
                              ,"NONTARGET"
                              ,"PHYLUM"
                              ,"SUBPHYLUM"
                              ,"CLASS"
                              ,"SUBCLASS"
                              ,"ORDER"
                              ,"FAMILY"
                              ,"FFG"
                              ,"TOLVAL"
                              ,"HABIT")

        column_names <- colnames(df_input)

        # QC Check for column names
        col_req_match <- required_columns %in% column_names
        col_missing <- required_columns[!col_req_match]

        shiny::validate(
            need(all(required_columns %in% column_names), paste0("Error\nChoose correct data separator; otherwise, you may have missing required columns\n",
                                                                 paste("Required columns missing from the data:\n")
                                                                 , paste("* ", col_missing, collapse = "\n")))
        )##END ~ validate() code


        #message(getwd())

        # Add "Results" folder if missing
        boo_Results <- dir.exists(file.path(".", "Results"))
        if(boo_Results==FALSE){
            dir.create(file.path(".", "Results"))
        }

        # Remove all files in "Results" folder
        fn_results <- list.files(file.path(".", "Results"), full.names=TRUE)
        file.remove(fn_results)

        # Write to "Results" folder - Import as TSV
        fn_input <- file.path(".", "Results", "data_import.tsv")
        write.table(df_input, fn_input, row.names=FALSE, col.names=TRUE, sep="\t")

        # Copy to "Results" folder - Import "as is"
        file.copy(input$fn_input$datapath, file.path(".", "Results", input$fn_input$name))

        # read.table(file = inFile$datapath, header = input$header,
        #          sep = input$sep, quote = input$quote)

        return(df_input)

    }##expression~END
    , filter="top", options=list(scrollX=TRUE)
    )##output$df_import_DT~END

    # b_Calc ####
    # Calculate IBI (metrics and scores) from df_import
    # add "sleep" so progress bar is readable
    observeEvent(input$b_Calc, {
        shiny::withProgress({
            #
            # Number of increments
            n_inc <- 6

            # sink output
            #fn_sink <- file.path(".", "Results", "results_log.txt")
            file_sink <- file(file.path(".", "Results", "results_log.txt"), open = "wt")
            sink(file_sink, type = "output", append = TRUE)
            sink(file_sink, type = "message", append = TRUE)
            # Log
            message("Results Log from MIEGLEtools Shiny App")
            message(Sys.time())
            inFile <- input$fn_input
            message(paste0("file = ", inFile$name))


            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Data, Initialize")
            Sys.sleep(0.25)

            #df_data <- 'df_import_DT'
            # Read in saved file (known format)
            df_data <- NULL  # set as null for IF QC check prior to import
            fn_input <- file.path(".", "Results", "data_import.tsv")
            df_data <- read.delim(fn_input, stringsAsFactors = FALSE, sep="\t")

            # QC, FAIL if TRUE
            if (is.null(df_data)){
                return(NULL)
            }

            # QC, FFG symbols
            FFG_approved <- c("CG", "CF", "PR", "SC", "SH")
            df_QC <- df_data
            df_QC[df_QC==""] <- NA


            N_FFG_wrong <- sum((na.omit(df_QC$FFG) %in% FFG_approved) == 0)
            if(N_FFG_wrong>0){
                message(paste0(N_FFG_wrong, "taxa have the incorrect FFG descriptor, please use the following:"))
                message("Replace 'Collector' with 'CG'")
                message("Replace 'Filterer' with 'CF'")
                message("Replace 'Predator' with 'PR'")
                message("Replace 'Scraper' with 'SC'")
                message("Replace 'Shredder' with 'SH'")
                message("Failure to change FFG to correct coding scheme will result in incorrect metric calculations")
            }


            # QC, N_TAXA = 0
            N_Taxa_zeros <- sum(df_data$N_TAXA == 0, na.rm = TRUE)
            if(N_Taxa_zeros>0){
                message("Some taxa in your dataset have a count (N_TAXA) of zero. Values for TAXAID with N_TAXA = 0 will be removed before calculations.")
            }

            # QC, Exclude as TRUE/FALSE
            Exclude.T <- sum(df_data$EXCLUDE==TRUE, na.rm=TRUE)
            if(Exclude.T==0){##IF.Exclude.T.START
                message("EXCLUDE column does not have any TRUE values. \n  Valid values are TRUE or FALSE.  \n  Other values are not recognized.")
            }##IF.Exclude.T.END

            # QC, NonTarget as TRUE/FALSE
            NonTarget.F <- sum(df_data$NONTARGET==FALSE, na.rm=TRUE)
            if(NonTarget.F==0){##IF.Exclude.T.START
                message("NONTARGET column does not have any FALSE values. \n  Valid values are TRUE or FALSE.  \n  Other values are not recognized.")
            }##IF.Exclude.T.END


            #appUser <- Sys.getenv('USERNAME')
            # Not meaningful when run online via Shiny.io

            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Calculate, Metrics (takes ~ 30-45s)")
            Sys.sleep(0.5)

            # prior to metric calculation, we need to add columns that aren't part of the dataset but need to be in the input dataframe
            # otherwise, metric.values.MI () will produce an error when on shinyapps.io (dated 2020-07-30)

            # convert Field Names to UPPER CASE
            names(df_data) <- toupper(names(df_data))

            # QC, Required Fields
            col.req <- c("SAMPLEID", "TAXAID", "N_TAXA", "EXCLUDE", "INDEX_NAME"
                         , "INDEX_REGION", "NONTARGET", "PHYLUM", "SUBPHYLUM", "CLASS", "SUBCLASS"
                         , "INFRAORDER", "ORDER", "FAMILY", "SUBFAMILY", "TRIBE", "GENUS"
                         , "FFG", "HABIT", "LIFE_CYCLE", "TOLVAL", "BCG_ATTR", "THERMAL_INDICATOR"
                         , "LONGLIVED", "NOTEWORTHY", "FFG2", "TOLVAL2", "HABITAT")
            col.req.missing <- col.req[!(col.req %in% toupper(names(df_data)))]

            # Add missing fields
            df_data[,col.req.missing] <- NA
            warning(paste("Metrics related to the following fields are invalid:"
                          , paste(paste0("   ", col.req.missing), collapse="\n"), sep="\n"))

            # calculate values and scores in two steps using BioMonTools
            # save each file separately

            # columns to keep
            keep_cols <- c("Lat", "Long")

            #df_metval <- BioMonTools::metric.values(fun.DF = df_data, fun.Community = "bugs", fun.MetricNames = MichMetrics, boo.Shiny = TRUE)

            df_metval <- suppressWarnings(metric.values.MI(fun.DF = df_data, fun.Community = "bugs",
                                                           fun.MetricNames = MichMetrics, fun.cols2keep=keep_cols, boo.Shiny = TRUE))

            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Metrics have been calculated!")
            Sys.sleep(1)

            # Log
            message(paste0("Chosen IBI from Shiny app = ", input$MMI))


            #
            # Save
            # fn_metval <- file.path(".", "Results", "results_metval.tsv")
            # write.table(df_metval, fn_metval, row.names = FALSE, col.names = TRUE, sep="\t")
            fn_metval <- file.path(".", "Results", "results_metval.csv")
            write.csv(df_metval, fn_metval, row.names = FALSE)
            #
            # QC - upper case Index.Name
            names(df_metval)[grepl("Index.Name", names(df_metval))] <- "INDEX.NAME"



            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Calculate, Scores")
            Sys.sleep(0.50)

            # Metric Scores
            #
            # Thresholds
            #fn_thresh <- file.path(system.file(package="BioMonTools"), "extdata", "MetricScoring.xlsx")
            #fn_thresh <- file.path(".", "Thresholds", "MetricScoring.xlsx")
            #df_thresh_metric <- readxl::read_excel(fn_thresh, sheet="metric.scoring")
            #df_thresh_index <- readxl::read_excel(fn_thresh, sheet="index.scoring")

            # Thresholds
            fn_thresh <- file.path(system.file(package="BioMonTools"), "extdata", "MetricScoring.xlsx")
            df_thresh_metric <- read_excel(fn_thresh, sheet="metric.scoring")
            df_thresh_index <- read_excel(fn_thresh, sheet="index.scoring")

            # run scoring code
            df_metsc <- metric.scores(DF_Metrics = df_metval, col_MetricNames = MichMetrics,
                                                   col_IndexName = "INDEX_NAME", col_IndexRegion = "INDEX_REGION",
                                                   DF_Thresh_Metric = df_thresh_metric, DF_Thresh_Index = df_thresh_index,
                                                   col_ni_total = "ni_total")


            # Save
            # fn_metsc <- file.path(".", "Results", "results_metsc.tsv")
            # write.table(df_metsc, fn_metsc, row.names = FALSE, col.names = TRUE, sep="\t")
            fn_metsc <- file.path(".", "Results", "results_metsc.csv")
            write.csv(df_metsc, fn_metsc, row.names = FALSE)

            # MAP requires df_metsc
            map_data$df_metsc <- df_metsc



            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Ben's code is magical!")
            Sys.sleep(0.75)

            # Plot
            #p1 <- ggplot(df_metsc, aes(IBI), fill=myCol_Strata, shape=myCol_Strata) +
            #            geom_dotplot(aes_string(fill=myCol_Strata), method="histodot", binwidth = 1/5) +
            #geom_dotplot(aes_string(fill=myCol_Strata)) +
            #           labs(x=myIndex) +
            #          geom_vline(xintercept = 3) +
            #           scale_x_continuous(limits = c(1, 5)) +
            # scale_fill_discrete(name="STRATA"
            #                     , breaks=c("COASTAL", "EPIEDMONT", "HIGHLAND")) +
            #          theme(axis.title.y=element_blank()
            #               , axis.ticks.y=element_blank()
            #              , axis.text.y=element_blank())
            #fn_p1 <- file.path(".", "Results", "results_plot_IBI.jpg")
            #ggplot2::ggsave(fn_p1, p1)


            # Increment the progress bar, and update the detail text.
            incProgress(1/n_inc, detail = "Create, Zip")
            Sys.sleep(0.50)

            # Create zip file
            fn_4zip <- list.files(path = file.path(".", "Results")
                                  , pattern = "^results_"
                                  , full.names = TRUE)
            zip(file.path(".", "Results", "results.zip"), fn_4zip)

            #zip::zipr(file.path(".", "Results", "results.zip"), fn_4zip) # used because regular utils::zip wasn't working
            # enable download button
            shinyjs::enable("b_downloadData")

            # #
            # return(myMetric.Values)
            # end sink
            #flush.console()
            sink() # console
            sink() # message
            #
        }##expr~withProgress~END
        , message = "Calculating IBI"
        )##withProgress~END
    }##expr~ObserveEvent~END
    )##observeEvent~b_CalcIBI~END

    # df_metric_values ####
    # output$df_metric_values <- DT::renderDT({
    #   # input$df_metric_values will be NULL initially. After the user
    #   # calculates an IBI, it will be a data frame with 'name',
    #   # 'size', 'type', and 'datapath' columns. The 'datapath'
    #   # column will contain the local filenames where the data can
    #   # be found.
    #
    #   # If haven't imported a file keep blank
    #   inFile <- input$fn_input
    #
    #   if (is.null(inFile)){
    #     return(NULL)
    #   }##IF~is.null~END
    #
    #   # Read in saved file (known format)
    #   df_met_val <- NULL
    #   fn_met_val <- file.path(".", "Results", "results_metval.tsv")
    #   df_met_val <- read.delim(fn_input, stringsAsFactors = FALSE, sep="\t")
    #
    #   boo_met_val <- file.exists(fn_met_val)
    #
    #   if (boo_met_val==FALSE){
    #     return(NULL)
    #   }
    #
    #   return(df_met_val)
    #
    # }##expr~END
    # , filter="top", options=list(scrollX=TRUE)
    # )##output$df_import~END

    # # df_metric_scores ####
    # output$df_metric_scores <- renderDT({
    #   # input$df_metric_scores will be NULL initially. After the user
    #   # calculates an IBI, it will be a data frame with 'name',
    #   # 'size', 'type', and 'datapath' columns. The 'datapath'
    #   # column will contain the local filenames where the data can
    #   # be found.
    #
    #   # If haven't imported a file keep blank
    #   inFile <- input$fn_input
    #
    #   if (is.null(inFile)){
    #     return(NULL)
    #   }##IF~is.null~END
    #
    #   # Read in saved file (known format)
    #   df_met_sc <- NULL
    #   fn_met_sc <- file.path(".", "Results", "results_metsc.tsv")
    #   df_met_sc <- read.delim(fn_input, stringsAsFactors = FALSE, sep="\t")
    #   boo_met_sc <- file.exists(fn_met_sc)
    #
    #   if (boo_met_sc==FALSE){
    #     return(NULL)
    #   } else {
    #     return(df_met_sc)
    #   }
    #
    # }##expr~END
    # , filter="top", options=list(scrollX=TRUE)
    # )##output$df_import~END


    # # plot_IBI ####
    # #output$plot_IBI <- renderPlotly(ggplotly(plot_BIBI))
    # output$plot_IBI <- renderImage({
    #   #
    #   # If haven't imported a file keep blank
    #   inFile <- input$fn_input
    #
    #   fn_plot <- file.path(".", "Results", "plot_IBI.jpg")
    #   boo_plot <- file.exists(fn_plot)
    #
    #
    #   if (is.null(inFile)==TRUE){# || boo_plot==FALSE){
    #     return(NULL)
    #   }##IF~is.null~END
    #
    #   # if (boo_plot==FALSE){
    #   #   return(NULL)
    #   # }
    #
    #   return(list(src = fn_plot
    #               , filetype = "image/jpeg"
    #               , width = 800
    #               )
    #         )##return~END
    #
    # }##expr~END
    # , deleteFile=FALSE
    # )##renderImage~END


    # b_downloadData ####

    # disable button unless have zip file
    # Enable in b_Calc instead
    # observe({
    #   fn_zip_toggle <- paste0("results", ".zip")
    #   shinyjs::toggleState(id="b_downloadData", condition = file.exists(file.path(".", "Results", fn_zip_toggle)) == TRUE)
    # })##~toggleState~END


    # Downloadable csv of selected dataset
    output$b_downloadData <- downloadHandler(
        # use index and date time as file name
        #myDateTime <- format(Sys.time(), "%Y%m%d_%H%M%S")

        filename = function() {
            paste(input$MMI, "_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".zip", sep = "")
        },
        content = function(fname) {##content~START
            # tmpdir <- tempdir()
            #setwd(tempdir())
            # fs <- c("input.csv", "metval.csv", "metsc.csv")
            # file.copy(inFile$datapath, "input.csv")
            # file.copy(inFile$datapath, "metval.tsv")
            # file.copy(inFile$datapath, "metsc.tsv")
            # file.copy(inFile$datapath, "IBI_plot.jpg")
            # write.csv(datasetInput(), file="input.csv", row.names = FALSE)
            # write.csv(datasetInput(), file="metval.csv", row.names = FALSE)
            # write.csv(datasetInput(), file="metsc.csv", row.names = FALSE)
            #
            # Create Zip file
            #zip(zipfile = fname, files=fs)
            #if(file.exists(paste0(fname, ".zip"))) {file.rename(paste0(fname, ".zip"), fname)}

            file.copy(file.path(".", "Results", "results.zip"), fname)

            #
        }##content~END
        #, contentType = "application/zip"
    )##downloadData~END

    ########################
    ##### Map Creation #####
    ########################


    # create quantile color palette to change color of markers based on index values
    scale_range <- c(0,100)
    qpal <- colorBin(c("red","yellow", "green"), domain = scale_range, bins = 5)

    output$mymap <- renderLeaflet({

      req(!is.null(map_data$df_metsc))

      df_data <- map_data$df_metsc

        # subset data by Index_Region

        East_data <- df_data %>%
          filter(INDEX_REGION == "EAST")

        VN_data <- df_data %>%
          filter(INDEX_REGION == "VERYNARROW")

        Nar_data <- df_data %>%
          filter(INDEX_REGION == "NARROW")

        WF_data <- df_data %>%
          filter(INDEX_REGION == "WESTFLAT")

        WS_data <- df_data %>%
          filter(INDEX_REGION == "WESTSTEEP")

        WW_data <- df_data %>%
          filter(INDEX_REGION == "WETWIDE")

        MSD_data <- df_data %>%
          filter(INDEX_REGION == "MIDSIZEDRY")


        leaflet() %>%
          addTiles() %>%
          addCircleMarkers(data = East_data, lat = ~LAT, lng = ~LONG
                           , group = "East", popup = paste("SampleID:", East_data$SAMPLEID, "<br>"
                                                           ,"Site Class:", East_data$INDEX_REGION, "<br>"
                                                           ,"Score pt_NonIns:", round(East_data$SC_pt_NonIns,2), "<br>"
                                                           ,"Score pi_IsopGastHiru:", round(East_data$SC_pi_IsopGastHiru,2), "<br>"
                                                           ,"Score pt_tv_toler:", round(East_data$SC_pt_tv_toler,2), "<br>"
                                                           ,"Score nt_Trich:", round(East_data$SC_nt_Trich,2), "<br>"
                                                           ,"Score nt_habit_cling:", round(East_data$SC_nt_habit_cling,2), "<br>"
                                                           ,"Score pi_tv_intol:", round(East_data$SC_pi_tv_intol,2), "<br>"
                                                           ,"<b> Index Value:</b>", round(East_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = WF_data, lat = ~LAT, lng = ~LONG
                           , group = "WestFlat", popup = paste("SampleID:", WF_data$SAMPLEID, "<br>"
                                                               ,"Site Class:", WF_data$INDEX_REGION, "<br>"
                                                               ,"Score pt_NonIns:", round(WF_data$SC_pt_NonIns,2), "<br>"
                                                               ,"Score pi_EPT:", round(WF_data$SC_pi_EPT,2), "<br>"
                                                               ,"Score pt_tv_intol:", round(WF_data$SC_pt_tv_intol,2), "<br>"
                                                               ,"Score pt_tv_toler:", round(WF_data$SC_pt_tv_toler,2), "<br>"
                                                               ,"Score pi_ffg_col:", round(WF_data$SC_pi_ffg_col,2), "<br>"
                                                               ,"Score pi_habit_sprawl:", round(WF_data$SC_pi_habit_sprawl,2), "<br>"
                                                               ,"<b> Index Value:</b>", round(WF_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = WS_data, lat = ~LAT, lng = ~LONG
                           , group = "WestSteep", popup = paste("SampleID:", WS_data$SAMPLEID, "<br>"
                                                                ,"Site Class:", WS_data$INDEX_REGION, "<br>"
                                                                ,"Score pi_habit_cling:", round(WS_data$SC_pi_habit_cling,2), "<br>"
                                                                ,"Score pi_EPTNoBaeHydro:", round(WS_data$SC_pi_EPTNoBaeHydro,2), "<br>"
                                                                ,"Score pt_tv_toler:", round(WS_data$SC_pt_tv_toler,2), "<br>"
                                                                ,"Score pi_ffg_col:", round(WS_data$SC_pi_ffg_col,2), "<br>"
                                                                ,"Score nt_Trich", round(WS_data$SC_nt_Trich,2), "<br>"
                                                                ,"<b> Index Value:</b>", round(WS_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = MSD_data, lat = ~LAT, lng = ~LONG
                           , group = "MidSizeDry", popup = paste("SampleID:", MSD_data$SAMPLEID, "<br>"
                                                                 ,"Site Class:", MSD_data$INDEX_REGION, "<br>"
                                                                 ,"Score nt_CruMol:", round(MSD_data$SC_nt_CruMol,2), "<br>"
                                                                 ,"Score pi_ffg_pred:", round(MSD_data$SC_pi_ffg_pred,2), "<br>"
                                                                 ,"Score pi_ffg_shred:", round(MSD_data$SC_pi_ffg_shred,2), "<br>"
                                                                 ,"Score pi_habit_cling:", round(MSD_data$SC_pi_habit_cling,2), "<br>"
                                                                 ,"Score pi_CruMol:", round(MSD_data$SC_pi_CruMol,2), "<br>"
                                                                 ,"Score nt_tv_toler:", round(MSD_data$SC_nt_tv_toler,2), "<br>"
                                                                 ,"Score pt_NonIns:", round(MSD_data$SC_pt_NonIns,2), "<br>"
                                                                 ,"<b> Index Value:</b>", round(MSD_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = Nar_data, lat = ~LAT, lng = ~LONG
                           , group = "Narrow", popup = paste("SampleID:", Nar_data$SAMPLEID, "<br>"
                                                             ,"Site Class:", Nar_data$INDEX_REGION, "<br>"
                                                             ,"Score pi_ffg_shred:", round(Nar_data$SC_pi_ffg_shred,2), "<br>"
                                                             ,"Score pt_NonIns:", round(Nar_data$SC_pt_NonIns,2), "<br>"
                                                             ,"Score pi_habit_climb:", round(Nar_data$SC_pi_habit_climb,2), "<br>"
                                                             ,"Score pi_EPT:", round(Nar_data$SC_pi_EPT,2), "<br>"
                                                             ,"Score pi_tv_toler:", round(Nar_data$SC_pi_tv_toler,2), "<br>"
                                                             ,"<b> Index Value:</b>", round(Nar_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = VN_data, lat = ~LAT, lng = ~LONG
                           , group = "VeryNarrow", popup = paste("SampleID:", VN_data$SAMPLEID, "<br>"
                                                                 ,"Site Class:", VN_data$INDEX_REGION, "<br>"
                                                                 ,"Score pi_ffg_shred:", round(VN_data$SC_pi_ffg_shred,2), "<br>"
                                                                 ,"Score pi_habit_cling:", round(VN_data$SC_pi_habit_cling,2), "<br>"
                                                                 ,"Score pt_NonIns:", round(VN_data$SC_pt_NonIns,2), "<br>"
                                                                 ,"Score nt_EPT:", round(VN_data$SC_nt_EPT,2), "<br>"
                                                                 ,"Score pi_Cru:", round(VN_data$SC_pi_Cru,2), "<br>"
                                                                 ,"Score pt_tv_intol:", round(VN_data$SC_pt_tv_intol,2), "<br>"
                                                                 ,"<b> Index Value:</b>", round(VN_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addCircleMarkers(data = WW_data, lat = ~LAT, lng = ~LONG
                           , group = "WetWide", popup = paste("SampleID:", WW_data$SAMPLEID, "<br>"
                                                              ,"Site Class:", WW_data$INDEX_REGION, "<br>"
                                                              ,"Score nt_NonIns:", round(WW_data$SC_nt_NonIns,2), "<br>"
                                                              ,"Score pi_ffg_scrap:", round(WW_data$SC_pi_ffg_scrap,2), "<br>"
                                                              ,"Score pi_IsopGastHiru:", round(WW_data$SC_pi_IsopGastHiru,2), "<br>"
                                                              ,"Score pi_NonIns:", round(WW_data$SC_pi_NonIns,2), "<br>"
                                                              ,"Score pi_Pleco:", round(WW_data$SC_pi_Pleco,2), "<br>"
                                                              ,"Score pt_tv_toler:", round(WW_data$SC_pt_tv_toler,2), "<br>"
                                                              ,"<b> Index Value:</b>", round(WW_data$Index, 2))
                           , color = ~qpal(Index), fillOpacity = 1, stroke = FALSE
                           , clusterOptions = markerClusterOptions()
          ) %>%
          addLegend(pal = qpal,
                    values = scale_range,
                    position = "bottomright",
                    title = "Values",
                    opacity = 1) %>%
          addLayersControl(overlayGroups = c("East", "WestFlat", "WestSteep", "MidSizeDry",
                                             "Narrow","VeryNarrow", "WetWide"),
                           options = layersControlOptions(collapsed = FALSE))

      }) ##renderLeaflet~END

})##shinyServer~END
