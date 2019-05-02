addressList <- list(
                    passing_address = "http://stats.nba.com/js/data/sportvu/passingData.js", 
                  rebounding_address = "http://stats.nba.com/js/data/sportvu/reboundingData.js", 
                    
                    shooting_address = "http://stats.nba.com/js/data/sportvu/shootingData.js")


readIt <- function(address) {
  web_page <- readLines(address)
  
  ## regex to strip javascript bits and convert raw to csv format
  x1 <- gsub("[\\{\\}\\]]", "", web_page, perl = TRUE)
  x2 <- gsub("[\\[]", "\n", x1, perl = TRUE)
  x3 <- gsub("\"rowSet\":\n", "", x2, perl = TRUE)
  x4 <- gsub(";", ",", x3, perl = TRUE)
  
  # read the resulting csv with read.table()
  nba <- read.table(textConnection(x4), header = T, sep = ",", skip = 2, stringsAsFactors = FALSE)
  return(nba)
}


df_list <- lapply(addressList, readIt)
