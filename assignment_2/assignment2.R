## loading the shinydashboard and other packages

source('install_load_packages.R')


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
