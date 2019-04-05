## loading the shinydashboard and other packages
## make sure to have all installed and loaded
library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(httr)
library(devtools)
library(stringr)
library(rvest)
library(reshape2)


## the following is an API interface for stats.NBA.com
## please install it in order to run the application

#devtools::install_github('stephematician/statsnbaR')

library(statsnbaR)

## get source files
source('utils.R')
source('ui.R')
source('server.R')

## runs the app
shinyApp(ui, server)