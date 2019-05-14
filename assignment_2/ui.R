#
# This is the user-interface definition of a Shiny web application.
#


## creating my dashboard
header <- dashboardHeader(
  title = "NBA Stats",
  dropdownMenu(
    type = "notifications",
    icon = icon("link", lib = 'glyphicon'),
    headerText = "Learn more about data at:",
    notificationItem(
      text = "stats.nba.com", 
      href = "https://stats.nba.com/",
      icon = icon("link", lib = 'glyphicon')
    ),
    notificationItem(
      text = "Stats Glossary", 
      href = "https://stats.nba.com/help/glossary/",
      icon = icon("link", lib = 'glyphicon')
    )
  )
)

sidebar <- dashboardSidebar(
  sidebarMenu(
  menuItem(
    "General",
    tabName = "general",
    icon = icon("home", lib = 'glyphicon')
  ),
  menuItem(
    "Team Comparison",
    tabName = "team_compare",
    icon = icon("bar-chart")
  ),
  menuItem(
    "Player Comparison",
    tabName = "player_compare",
    icon = icon("bar-chart")
  ),
  menuItem(
    "Team Analysis",
    tabName = "team_stat",
    icon = icon("line-chart")
  ),
  menuItem(
    "Player Analysis",
    tabName = "player_stat",
    icon = icon("pie-chart")
  )
))


body <- dashboardBody(
  tabItems(
    
    ## General tab content
    tabItem(tabName = "general",
            fluidPage(
              fluidRow(
                column(7,
                       offset = 2,
                       h3("Team Standings"),
                       plotlyOutput("win_percentage") %>% withSpinner(color="#0dc5c1")
                ),
                column(7,
                       offset = 2,
                       h3("Players Performance"),
                       plotlyOutput("player_distribution") %>% withSpinner(color="#0dc5c1")
                  
                )
              )
            )
    ),
    
    # Team comparison tab content
    tabItem(tabName = "team_compare",
            fluidPage(
              fluidRow(
                box(
                  title = "Team 1",
                  status = "danger",
                  solidHeader = TRUE,
                  collapsible = F,
                  width = 4,
                  height = 330,
                  htmlOutput("team1ImgOutput"),
                  HTML(
                    '<center><div id="team_info1" class="shiny-html-output"></div></center>'
                  )
                ),
                
                box(
                  title = "Controls",
                  status = "warning",
                  solidHeader = TRUE,
                  width = 4,
                  height = 330,
                  selectInput(
                    inputId = "seasonInput5",
                    "Choose a season:",
                    choices = get_seasons(),
                    selected = 2018
                  ),
                  uiOutput("teamOutput1"),
                  uiOutput("teamOutput2"),
                  uiOutput("teamCompareBtn")
                ),
                
                box(
                  title = "Team 2",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = F,
                  width = 4,
                  height = 330,
                  htmlOutput("team2ImgOutput"),
                  HTML(
                    '<center><div id="team_info2" class="shiny-html-output"></div></center>'
                  )
                )
              ),
              
              fluidRow(
                  div(plotlyOutput("teamComparePlot1") %>% 
                        withSpinner(color="#0dc5c1"))
              )
            )
    ),
    
    # Player comparison tab content
    tabItem(tabName = "player_compare",
            fluidPage(
              fluidRow(
                box(
                  title = "Player 1",
                  status = "danger",
                  solidHeader = TRUE,
                  collapsible = F,
                  width = 4,
                  height = 330,
                  htmlOutput("player1imgOutput"),
                  HTML(
                    '<center><div id="player_info1" class="shiny-html-output"></div></center>'
                  )
                ),
                
                box(
                  title = "Controls",
                  status = "warning",
                  solidHeader = TRUE,
                  width = 4,
                  height = 330,
                  selectInput(
                    inputId = "seasonInput1",
                    "Choose a season:",
                    choices = get_seasons(),
                    selected = 2018
                  ),
                  uiOutput("playerOutput1"),
                  uiOutput("playerOutput2"),
                  uiOutput("playerCompareBtn")
                ),
                
                box(
                  title = "Player 2",
                  status = "info",
                  solidHeader = TRUE,
                  collapsible = F,
                  width = 4,
                  height = 330,
                  htmlOutput("player2imgOutput"),
                  HTML(
                    '<center><div id="player_info2" class="shiny-html-output"></div></center>'
                  )
                )
              ),
              
              fluidRow(
                  div(plotlyOutput("playerComparePlot1") %>% 
                        withSpinner(color="#0dc5c1"))
              )
            )
    ),
    
    ## Team tab content
    tabItem(tabName = "team_stat",
            fluidPage(
              fluidRow(
                  h2("General Team Performance"),
                  column(3, style = "background-color:rgba(255, 255, 255, 0);",
                    selectInput(
                      inputId = "seasonInput2",
                      "Choose a season:",
                      choices = get_seasons(),
                      selected = 2018
                      )
                    ),
                  
                  column(3, style = "background-color:rgba(255, 255, 255, 0);",
                         uiOutput("teamOutput3")
                         ),
                  
                  column(12, style = "background-color:rgba(255, 255, 255, 0);",
                         div(plotlyOutput("general_teamPlot") %>% 
                               withSpinner(color="#0dc5c1"))
                         )
               
              )
            )
    ),
    
    # Player tab content
    tabItem(tabName = "player_stat",
            fluidPage(
              fluidRow(
                  h2("Player Shots"),
                  width = 12,
                  solidHeader = TRUE,
                  column(2,
                         selectInput(
                           inputId = "seasonInput4",
                           "Choose a season:",
                           choices = get_seasons(),
                           selected = 2018
                         )
                  ),
                  column(2,
                         uiOutput("playerOutput3")
                  ),
                  column(2,
                         selectInput(
                           inputId = "chartTypeInput1",
                           "Choose a plot type:",
                           choices = c("Shot Types", "Hit and Miss", "Shot Density", "Shot Accuracy"),
                           selected = "Shot Types"
                         )
                  )
              ),
              
              fluidRow(
                column(8,
                       style = "margin-top: 0",
                       plotOutput("shortCharts") %>%
                         withSpinner(color="#0dc5c1")
                ),
                
                column(4,
                       style = "margin-top: -10px",
                       htmlOutput("playerName"),
                       htmlOutput("player3Img"),
                       HTML(
                         '<center><div id="playerInfo" class="shiny-html-output"></div></center>'
                       )
                )
            )
          )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = 'blue')