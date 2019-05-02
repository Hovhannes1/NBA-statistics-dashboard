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
    "Player Comparison",
    tabName = "compare",
    icon = icon("bar-chart"),
    badgeColor = "purple"
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
    tabItem(tabName = "general",
            fluidPage(
              fluidRow( 
                column(6,
                       plotlyOutput("win_percentage")
                       
                ),
                column(6,
                  title = "Player Performance",
                  plotlyOutput("")
                  
                )
              )
            )
    ),
    
    # Comparison tab content
    tabItem(tabName = "compare",
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
                    '<center><div id="info1" class="shiny-html-output"></div></center>'
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
                  uiOutput("player1Output"),
                  uiOutput("player2Output"),
                  uiOutput("compareBtn")
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
                    '<center><div id="info2" class="shiny-html-output"></div></center>'
                  )
                )
              ),
              
              fluidRow(
                box(
                  width = 12,
                  div(style = 'overflow-x: scroll', plotlyOutput("comparePlot1")))
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
                         uiOutput("teamOutput1")),
                  column(1,
                         uiOutput("teamSeasonBtn"), style="padding-top: 24px"
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
                         htmlOutput("playerImg1"),
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
    ),
    
    tabItem(tabName = "raw_data",
        fluidPage(
              fluidRow(
                box(
                  column(2,selectInput(
                    inputId = "seasonInput3",
                    "Choose a season:",
                    choices = get_seasons(),
                    selected = 2018
                    )), 
                  dataTableOutput("data_table1"),
                  style="overflow: auto",
                  width = 12
                )
            )
          )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = 'blue')