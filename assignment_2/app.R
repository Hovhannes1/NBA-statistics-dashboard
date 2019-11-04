## loading the shinydashboard and other packages

source('install_load_packages.R')

## get the source files
source('utils.R')
source('ui.R')
source('server.R')

## run the app
shinyApp(ui, server)
