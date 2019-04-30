#
# This is the user-interface definition of a Shiny web application.
#


## creating my dashboard
header <- dashboardHeader(
  title = "Player Comparison",
  dropdownMenu(
    type = "messages",
    messageItem(from = "Mark Hovsepyan",
                message = "Welcome! Let's start!")
  ),
  dropdownMenu(
    type = "tasks",
    messageItem(from = "Hovhannes Stepanyan",
                message = "Let's win together")
  ),
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "Please read instructions to start",
      icon = icon("info-circle"),
      status = "success"
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
    "Comparison",
    tabName = "compare",
    icon = icon("bar-chart"),
    badgeLabel = "app",
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
  ),
  menuItem(
    "Explore Data",
    tabName = "raw_data",
    icon = icon("bar-chart")
  ),
  menuItem(
    "NBA Official Satistics",
    icon = icon("send", lib = 'glyphicon'),
    href = "https://stats.nba.com"
  )
))


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "general",
            fluidPage(
              fluidRow(
                box(
                  title = "Team Performance",
                  width = 6,
                  div(style = 'overflow-x: scroll', plotlyOutput("win_percentage"))
                ),
                box(
                  title = "Team",
                  width = 6,
                  div(style = 'overflow-x: scroll', plotlyOutput(""))
                )
              ),
              
              fluidRow(
                box(),
                box()
              )
            )
    ),
    
    # Comparison tab content
    tabItem(tabName = "compare",
            fluidPage(
              fluidRow(
                box(
                  title = "Player 1",
                  status = "warning",
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
                  status = "danger",
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
                  uiOutput("compareOutput")
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
                         uiOutput("teamSeason_output"), style="padding-top: 24px"
                  ),
                  column(12,div(style = 'overflow-x: scroll', plotlyOutput("general_teamPlot")))
                )
               
              )
            )
    ),
    
    # Player tab content
    tabItem(tabName = "compare",
            fluidPage(
              uiOutput("BallR")
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
    ), 

    tabItem(tabName = "sources",
            h4(
              "All the data is taken from",
              a("NBA.com", href = "https://stats.nba.com/")
            )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = 'blue')