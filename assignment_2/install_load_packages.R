required_packages = c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "plotly",
  "plyr",
  "dplyr",
  "DT",
  "httr",
  "RCurl",
  "devtools",
  "stringr",
  "rvest",
  "reshape2",
  "grid",
  "gridExtra",
  "hexbin",
  "rjson",
  "jpeg",
  "shinycssloaders"
)

packages_to_install <- required_packages[!(required_packages %in% installed.packages()[, 1])]

if (length(packages_to_install) > 0) {
  install.packages(packages_to_install, repos = "https://cran.rstudio.com")
}

lapply(required_packages, require, character.only = TRUE)

if (!("statsnbaR" %in% installed.packages()[, 1])) {
  devtools::install_github('stephematician/statsnbaR')
}

library(statsnbaR)
