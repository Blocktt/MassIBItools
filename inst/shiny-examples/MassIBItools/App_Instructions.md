---
title: "Instructions and Background Information"
date: "2020-10-12 16:51:13"
output:
  md_document:
    toc: yes
---



# Instructions

MassIBItools is a product developed by Tetra Tech, Inc. designed for the Massachusetts Department of Environmental Protection (MassDEP) to use in calculation of benthic macroinvertebrate metrics and index values for Massachusetts streams using Indices of Biotic Integrity (IBI). For more information, see the Background section.

R is an open source programming language and software environment for statistical computing.

Shiny by RStudio, is an interactive web application that serves as a graphical user interface for MassIBItools.

Shiny application developed by Ben Block (Ben.Block@tetratech.com).
R code written by Ben Block and Erik Leppo (Erik.Leppo@tetratech.com).

## Foreword
The MassIBItools shiny app was produced by Tetra Tech, Inc. to provide Mass DEP a tool to calculate IBI index scores for any future sampling efforts. The app is streamline and easy to operate, and only requires an input dataset to function. Index scores are calculated based on user inputs which have the potential to produce incorrect results. Therefore, the first portion of the user manual provides detailed instructions on how to properly format the input file. The next section discusses app operation. Finally, a frequently asked questions (FAQ) section may provide beneficial answers to frequently asked questions. Feel free to contact Ben Block should any issues or questions arise. 

## Input data set
### Required Columns
MassIBItools requires an input dataset to be properly formatted and contain the appropriate information. Columns required include: 

* INDEX_NAME
* SAMPLEID
* INDEX_REGION
* LAT
* LONG
* STATIONID
* COLLDATE
* COLLMETH
* TAXAID
* N_TAXA
* EXCLUDE
* NONTARGET
* PHYLUM
* SUBPHYLUM
* CLASS
* ORDER
* FAMILY
* SUBFAMILY
* TRIBE
* GENUS
* FFG
* TOLVAL
* HABIT
* THERMAL_INDICATOR
* LIFE_CYCLE

The app will notify the user if the input dataset is missing columns. Note, column headers need to be capitalized and spelled exactly as shown. 

### Input data format   
The input dataset needs to be in “long” format which means that columns are reduced, and each row is assigned an observation. The input dataset for MassIBItools should have one row for every SAMPLEID and observed TAXAID. Duplicate, replicate, or revisit samples must have the information coded in to the SAMPLEID. TAXAID should never include life stage designations because metrics are calculated based on taxonomy only. Index scores will likely be incorrect if life stage designations are included. For example, Haliplidae_larvae and Haliplidae_adult would be considered as two separate taxa by the app and would be reflected in index scores. For this example, each sample should include only one entry for Haliplidae. Certain columns require specific inputs (Table 1).

### Table 1. Input options for select columns. Any other input will result in an error. Note, Input Options are case-specific; some include underscores. 

|Input Column Name |Input Options                         |Comments                                                                                                                                                                    |
|:-----------------|:-------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|INDEX_NAME        |MassDEP_2019_Bugs                     |NA                                                                                                                                                                          |
|INDEX_REGION      |CENTRALHILLS, WESTHIGHLANDS, MULTIHAB |Describing the Site Class                                                                                                                                                   |
|EXCLUDE           |TRUE/FALSE                            |“TRUE” if the taxon is also represented by another taxon at a more refined taxonomic level in the same sample; otherwise “FALSE”                                            |
|NONTARGET         |TRUE/FALSE                            |“TRUE” if the record was intended and valid for index calculation. “FALSE” if the record is not valid (e.g., terrestrial organism or counted after the official subsample). |
|FFG               |CF, CG, PR, SC, SH                    |Representing collector-filterer, collector-gatherer, predator, scraper, and shredder, respectively. Input NA for missing data.                                              |
|HABIT             |BU, CB, CN, SK, SP, SW                |Representing burrower, climber, clinger, skater, sprawler, and swimmer, respectively. Input NA for missing data.                                                            |
|TAXAID            |<text describing taxa>                |These are not required to match any external lists, though matching might have been used to associate taxa with traits for the input file                                   |
|N_TAXA            |<non-negative integer>                |This represents the count of individuals observed in the sample.                                                                                                            |
|LIFE_CYCLE        |uni, semi, multi                      |Representing in the voltanism attirbute for an invertebrate.                                                                                                                |

## App Instructions

Once open, the user will see the IBI calculator interface. The user should follow the onscreen instructions as follows:

1. Load file
    + An example input file can be downloaded from Github [EXAMPLE LINK](https://github.com/Blocktt/MassIBItools/tree/master/inst/shiny-examples/MassIBItools/Examples)
    + Choose Separator. The separator indicates how the data is stored. Comma indicates the input file is a comma-separated file (.csv). Tab indicates the input file is a tab-separated file (.txt or .tsv). Finally, Semicolon indicates the input file is a semicolon-separated file which is uncommon in the United States but common in Western-European countries. Be certain that the designated separator is not used in any of the text fields (e.g., for multiple FFG, separate with a semicolon).
    + Choose Quote. The quote indicates how the data is stored. Double quote is the most common.
    + Choose file to upload. Hit the browse button and search for the input file. 
    + Once uploaded, make sure data is correct in the viewer. If the incorrect Separator or Quote is chosen, you may receive an error or the data may look incorrect in the viewer. 

2. Calculate IBI

3. Download results
    + Select the button to download a zip file with inputs and results.
    + Check ‘results_log.txt’ for any warnings or messages. Note, some warnings are automatically generated by R. Feel free to reach out to Ben Block (Ben.Block@tetratech.com) for any questions related to warnings.

4. Use interactive map and plots for data exploration
    + Navigate to the top of the page and click on the “Data Explorer” tab.
    + Prior to metric scores calculation, a map will not be visible.
    + Once metric scores are calculated, a map will become visible.
    + Sites are clustered when zoomed out for increased visibility - zoom for detail.
    + Sites are color coded by their Index Score value - click on a site for more info.
    + The map can be filtered based on INDEX_REGION using the checkbox group in the upper right. 

### Frequently asked questions and troubleshooting

1. Why am I getting an error saying that I am missing columns even when I am not?
    + You may have incorrectly spelled a given column. Try writing the column in all capital letters. Also, some columns (e.g., INDEX_REGION) require an underscore to separate the two words.

2. Why does my data look strange in the data viewer?
    + You likely have the incorrect Separator or Quote selected. Otherwise, there may be commas in text fields when the comma separator is selected.

3. The IBI calculation is taking forever to calculate, has the app frozen?
    + Even though R works remarkably fast, a large dataset will cause the app to slow down. The estimate is approximately 30 seconds for small datasets; however, this could extend to a few minutes for large datasets.

4. Why is there no map shown in the “Sites and Scores Map” tab?
    + The map requires the results of the IBI calculator to render.

# Background: Massachusetts kick net IBIs (v1; 9/24/2020)
Indices of Biotic Integrity (IBI) were calibrated for Massachusetts Department of Environmental Protection (MassDEP) benthic macroinvertebrate kick net samples in two naturally distinct regions: Western Highlands and Central Hills (Figure 1). Input metrics for the Western Highlands and Central Hills IBIs are shown in Tables 1 & 2, respectively. The new IBIs will improve MassDEP’s diagnostic ability to identify degradation in biological integrity and water quality. Full documentation of development of the kick net IBIs can be found in Jessup and Stamp (2020).

<!-- ![Figure 1. Macroinvertebrate kick IBI stream classes. The southeast areas (Narragansett/Bristol Lowlands, Cape Cod, and the Islands) were excluded because they had insufficient RBP kick net data to develop an IBI at this time.](figures/figure1.png) -->

### Table 2. Metrics in the Western Highlands IBI, with scoring formulas. Trend is the direction of metric response with increasing stress. 

|Metric abbreviation |Metric                                                                         |Trend |Scoring formula               |
|:-------------------|:------------------------------------------------------------------------------|:-----|:-----------------------------|
|nt_total            |Number of taxa - total                                                         |Dec.  |100*(metric value)/ 38.8      |
|pi_Pleco            |Percent individuals - Order Plecoptera                                         |Dec.  |100*(metric value)/ 18.3      |
|pi_ffg_filt         |Percent individuals - Functional Feeding Group (FFG) - collector-filterer (CF) |Inc.  |100*(50.5-metric value)/ 40.7 |
|pi_ffg_shred        |Percent individuals - FFG - shredder (SH)                                      |Dec.  |100*(metric value)/ 23        |
|pi_tv_intol         |Percent individuals - tolerance value - intolerant = 3                         |Dec.  |100*(metric value)/ 51.5      |
|x_Becks             |Becks Biotic Index*                                                            |Dec.  |100*(metric value)/ 36.8      |

*Beck’s Biotic Index = 2 x [Class 1 Taxa]+[Class 2 Taxa] where Class 1 taxa have tolerance values of 0 or 1 and Class 2 taxa have tolerance values of 2, 3 or 4.

### Table 3. Metrics in the Central Hills IBI, with scoring formulas. Trend is the direction of metric response with increasing stress.

|Metric abbreviation |Metric                                                                              |Trend |Scoring formula               |
|:-------------------|:-----------------------------------------------------------------------------------|:-----|:-----------------------------|
|nt_total            |Number of taxa - total                                                              |Dec.  |100*(metric value)/ 34.9      |
|pt_EPT              |Percent taxa - Orders Ephemeroptera, Plecoptera & Trichoptera (EPT)                 |Dec.  |100*(metric value)/ 54.5      |
|pi_Ephem NoCaeBae   |Percent individuals - Order Ephemeroptera, excluding Families Caenidae and Baetidae |Dec.  |100*(metric value)/ 13.9      |
|pi_ffg_filt         |Percent individuals - Functional Feeding Group (FFG) - collector-filterer (CF)      |Inc.  |100*(79.9-metric value)/ 66.9 |
|pt_ffg_pred         |Percent taxa - Functional Feeding Group (FFG) - predator (PR)                       |Dec.  |100*(metric value)/ 28.5      |
|pt_tv_intol         |Percent taxa - tolerance value - intolerant = 3                                     |Dec.  |100*(metric value)/ 39.1      |
