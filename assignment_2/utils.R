## util functions for the application

## get the seasons
## in nba stat there was only data starting from 1996 that was available in the same format
get_seasons <- function(start = 1996) {
  seasons <- start:2018
  
}

## get team years total/pergame data
get_team_seasons <- function(teamID, permode = "PerGame") {
  shotURL <- paste("https://stats.nba.com/stats/teamyearbyyearstats/?teamid=",teamID,"&leagueid=00&PerMode=",permode,"&seasontype=Regular%20Season", sep = "")
    
  # import from JSON
  teamSeasons <- fromJSON(file = shotURL, method="C")
  
  teamSeasonsf <- as.data.frame(matrix(do.call(cbind, teamSeasons$resultSets[[1]]$rowSet), ncol = 34, byrow = TRUE))
  
  teamSeasonsf[teamSeasonsf == 'N/A' | teamSeasonsf == 'NULL'] = NA
  
  colnames(teamSeasonsf) <- teamSeasons$resultSets[[1]]$headers
  

  teamSeasonsf
}


## get one season of team data
get_team_single_season <- function(season, df) {
  s_next <- season - 2000 + 1
  one_season <- df %>%
    filter(YEAR == paste(season, '-', s_next, sep = ""))
  
  one_season
}


## get games data by season
get_games_by_season <- function(season) {
  team_stat <- team_game_logs(league = "nba", season =  season)
  
  team_stat <- na.omit(team_stat)
  
  team_stat
}


## get team game data by season
get_team_games_data <- function(df, team) {
  one_team <- df %>%
    filter(team_name == team)
  
  one_team
}


## get team names
get_team_list <- function(df) {
  team_df <- df %>%
    select(team_name) %>%
    unique()
  
  team_df$team_name <- sort(team_df$team_name)
  
  team_df
}

## get team ID from name
get_teamID_from_name <- function(teamName, df) {
  team_id <- df %>%
    filter(team_name == teamName) %>%
    select(team_id)
  
  team_id <- as.numeric(team_id[1, 1])
}

## getting total player statistics by season
get_players_by_season_total <- function(season) {
  filter <- filter_per_player(league = "nba", season = season)
  player_stat <- per_player_agg(filter)
  colnames(player_stat)[2] <- "Player"
  colnames(player_stat)[4] <- "Team"
  colnames(player_stat)[5] <- "Age"
  
  player_stat <- na.omit(player_stat)
  
  player_stat
  
}


## get average data for season
get_players_by_season_pergame <- function(season) {
  players_total <- get_players_by_season_total(season)
  
  players_avg <- players_total[, 1:6]
  players_avg[, 7:8] <- (players_total[, 7:8] / players_total[, 6]) * 100
  players_avg[, 9:26] <- players_total[, 9:26] / players_total[, 6]
  
  players_avg
}


## get the list of players
get_player_list <- function(df) {
  player_df <- df %>%
    select(Player) %>%
    unique()
  player_df$Player <- sort(player_df$Player)
  
  player_df
}


## get player ID from name
get_playerID_from_name <- function(playerName, df) {
  player_id <- df %>%
    filter(Player == playerName) %>%
    select(person_id)
  
  player_id <- as.numeric(player_id[1, 1])
}


## get player table
get_player_table <- function(player, df) {
  player_table_df <- df %>%
    filter(Player == player) %>%
    select(-c(1, 3))
  player_table_df
}


## get player age
get_player_age <- function(player_table_df) {
  player_table_df["Age"] %>% unique()
}


## get player team
get_player_team <- function(player_table_df) {
  player_table_df["Team"]
}


## getting player pictures
get_pic_link <- function(player) {
  split <- str_split(tolower(player), " ")
  name <- unlist(split)
  two <- str_sub(name[1], 1, 2)
  five <- str_sub(name[2], 1, 5)
  first <- "01"
  second <- "02"
  third <- "03"
  # placeholder
  "https://d2p3bygnnzw9w3.cloudfront.net/req/999999999/images/klecko/placeholder.jpg"
  convention <- paste0(five, two, first)
  link <-
    paste0(
      "https://d2cwpp38twqe55.cloudfront.net/req/201712064/images/players/",
      convention,
      ".jpg"
    )
  link
}


## get player shots data
get_player_shots <- function(playerID, season) {
  s_next <- season - 2000 + 1
  shotURL <- paste("http://stats.nba.com/stats/shotchartdetail?CFID=33&CFPARAMS=",season,"-",s_next,"&ContextFilter=&ContextMeasure=FGA&DateFrom=&DateTo=&PlayerPosition=&GameID=&GameSegment=&LastNGames=0&LeagueID=00&Location=&MeasureType=Base&Month=0&OpponentTeamID=0&Outcome=&PaceAdjust=N&PerMode=PerGame&Period=0&PlayerID=",playerID,"&PlusMinus=N&Position=&Rank=N&RookieYear=&Season=",season,"-",s_next,"&SeasonSegment=&SeasonType=Regular+Season&TeamID=0&VsConference=&VsDivision=&mode=Advanced&showDetails=0&showShots=1&showZones=0", sep = "")
  
  # import from JSON
  shotData <- fromJSON(file = shotURL, method="C")
  
  # unlist shot data, save into a data frame
  shotDataf <- as.data.frame(matrix(unlist(shotData$resultSets[[1]][[3]]), ncol=24, byrow = TRUE))
  
  # shot data headers
  colnames(shotDataf) <- shotData$resultSets[[1]][[2]]
  
  # covert x and y coordinates into numeric
  shotDataf$LOC_X <- as.numeric(as.character(shotDataf$LOC_X))
  shotDataf$LOC_Y <- as.numeric(as.character(shotDataf$LOC_Y))
  shotDataf$SHOT_DISTANCE <- as.numeric(as.character(shotDataf$SHOT_DISTANCE))
  
  shotDataf
}
