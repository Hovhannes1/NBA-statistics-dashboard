#
# This is the user-interface definition of a Shiny web application.
#


## creating my dashboard
header <- dashboardHeader(
  title = "NBA Stats",
  dropdownMenu(
    type = "messages",
    notificationItem(
      a("stats.nba.com", href = "https://stats.nba.com/")
    )
  )
)

sidebar <- dashboardSidebar(sidebarMenu(
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
                column(6,
                       plotlyOutput("win_percentage")
                       
                ),
                column(6,
                       title = "Player Performance",
                       plotlyOutput("player_distribution")
                  
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
                  status = "danger",
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
                box(
                  width = 12,
                  div(style = 'overflow-x: scroll', plotlyOutput("teamComparePlot1")))
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
                box(
                  width = 12,
                  div(style = 'overflow-x: scroll', plotlyOutput("playerComparePlot1")))
              )
            )
    ),
    
    ## Team tab content
    tabItem(tabName = "team_stat",
            fluidPage(
              fluidRow(
                box(
                  h2("General Team Performance"),
                  width = 12,
                  solidHeader = TRUE,
                  column(3,
                    selectInput(
                      inputId = "seasonInput2",
                      "Choose a season:",
                      choices = get_seasons(),
                      selected = 2018
                    )),
                  column(3,
                         uiOutput("teamOutput3")),
                  column(1,
                         uiOutput("teamSeasonBtn"), 
                         style="padding-top: 24px"
                  ),
                  column(12,div(style = 'overflow-x: scroll', plotlyOutput("general_teamPlot")))
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
                  column(3,
                         selectInput(
                           inputId = "seasonInput4",
                           "Choose a season:",
                           choices = get_seasons(),
                           selected = 2018
                         )
                  ),
                  column(3,
                         uiOutput("playerOutput3")
                  ),
                  column(1,
                         uiOutput("shotChartBtn"), style="padding-top: 24px"
                  ),
                  column(5,
                         textOutput("playerName"),
                         htmlOutput("player3Img"),
                         HTML(
                           '<center><div id="playerInfo" class="shiny-html-output"></div></center>'
                         )
                  )
              ),
              
              fluidRow(
                column(6,
                       plotOutput("shortChart1")
                ),
                column(6,
                       plotOutput("shortChart2")                      
                ),
                column(6,
                       plotOutput("shortChart3")
                ),
                column(6,
                       plotOutput("shortChart4")                      
                )
            )
          )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = 'blue')