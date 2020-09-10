#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
# library(plotly)
# library(shinyjs) # used for download button enable

# Define UI for application that draws a histogram
shinyUI(navbarPage("Massachusetts IBI Calculator v0.1.0.900",
                   tabPanel("Calculator",
                            # SideBar
                            sidebarLayout(
                                sidebarPanel(
                                    # 0. Progress
                                    h3("App Steps")
                                    # , htmlOutput("vig")
                                    #, p("1_LoadData, 2_CalcMetrics, 3_CalcIndex, 4_DownloadResults")
                                    , h4("1. Load File")
                                    , h5("Select file parameters")
                                    , checkboxInput('header', 'Header', TRUE)
                                    , radioButtons('sep', 'Separator',
                                                   c(Comma=',',
                                                     Semicolon=';',
                                                     Tab='\t'),
                                                   ',')
                                    , radioButtons('quote', 'Quote',
                                                   c(None='',
                                                     'Double Quote'='"',
                                                     'Single Quote'="'"),
                                                   '"')
                                    #, tags$hr()
                                    , fileInput('fn_input', 'Choose file to upload',
                                                accept = c(
                                                    'text/csv',
                                                    'text/comma-separated-values',
                                                    'text/tab-separated-values',
                                                    'text/plain',
                                                    '.csv',
                                                    '.tsv'
                                                )
                                    )##fileInput~END
                                    #, tags$hr()
                                    , h4("2. Calculate IBI")
                                    , selectInput("MMI", "Select an IBI to calculate:",
                                                  choices=MMIs)
                                    , actionButton("b_Calc", "Calculate Metric Values and Scores")
                                    , tags$hr()
                                    , h4("3. Download Results")

                                    # Button
                                    , p("Select button to download zip file with input and results.")
                                    , p("Check 'results_log.txt' for any warnings or messages.")
                                    , useShinyjs()
                                    , shinyjs::disabled(downloadButton("b_downloadData", "Download"))

                                )##sidebarPanel~END
                                , mainPanel(
                                    tabsetPanel(type="tabs"
                                                # , tabPanel("TESTING"
                                                #            , htmlOutput("vig")
                                                #            , textOutput("fn_input")
                                                #            , useShinyjs()
                                                #            , runcodeUI(code="shinyjs::alert('Hello!')")
                                                #            )
                                                # , tabPanel("Directions"
                                                #            , p("Import data file."))
                                                , tabPanel("Data, Import"
                                                           #, tableOutput('df_import'))
                                                           , DT::dataTableOutput('df_import_DT'))
                                                # , tabPanel("Data QC"
                                                #            , h4("QC on the imported data")
                                                #             , p("Future implementation."))
                                                # , tabPanel("Results, Metric Values"
                                                #            , DT::dataTableOutput('df_metric_values'))
                                                # , tabPanel("Results, Metric Scores"
                                                #            , DT::dataTableOutput('df_metric_scores'))
                                                # , tabPanel("Results, Plot"
                                                #            #, plotlyOutput("plot_IBI", , height = "90%")
                                                #            , imageOutput("plot_IBI")
                                                #            )
                                    )##tabsetPanel~END
                                )##mainPanel~END

                            )##sidebarLayout~END

            ),## tabPanel~END
            tabPanel("Site and Scores Map"
                     , titlePanel("Site and Scores Map")
                     , h5("The map below will be generated once metric values and scores have been calculated.")
                     , h5("Sites are clustered when zoomed out for increased visibility - zoom in for added detail!")
                     , h5("Sites are color coded by their Index Score value - click on a site for more info!")
                     , sidebarLayout(
                       sidebarPanel(
                         helpText("Use the drop down menu to select a Sample ID.")
                         ,selectInput("siteid.select", "Select Sample ID:"
                                       , "")##selectInput~END

                         , br()
                         #, actionButton("zoom.comid", "Zoom to Selected ComID")
                         , p("After choosing a Sample ID the map will zoom to its location.")

                       )##sidebarPanel.END
                       , mainPanel(
                         tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}")
                         , leafletOutput("mymap", height = "85vh")
                       )##mainPanel.END
            ) ## tabPanel~END
        )## navbarPage~END
))## shinyUI~END
