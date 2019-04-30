
required_packages = c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "plotly",
  "dplyr",
  "DT",
  "httr",
  "devtools",
  "stringr",
  "rvest",
  "reshape2",
  "hexbin",
  "jsonlite"
)

packages_to_install <-required_packages[!(required_packages %in% installed.packages()[, 1])]

if (length(packages_to_install) > 0) {
  install.packages(packages_to_install, repos = "https://cran.rstudio.com")
}

lapply(required_packages, require, character.only = TRUE)
