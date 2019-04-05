#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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
    "Information",
    tabName = "contact",
    icon = icon("envelope-o")
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
                  h2("General Team Performance"),
                  width = 12
                )
              ),
              
              fluidRow(
                box(
                  title = "Controls",
                  status = "danger",
                  solidHeader = TRUE,
                  width = 4,
                  height = 330,
                  selectInput(
                    inputId = "seasonInput2",
                    "Choose a season:",
                    choices = get_seasons(),
                    selected = 2018
                  ),
                  selectInput(
                    inputId = "teamInput1",
                    "Choose a team:",
                    choices = get_team_list(get_teams_by_season()),
                    selected = "Chicago Bulls"
                  ),
                  uiOutput("team_ptsOutput")
                ),
                
                box(
                  title = "Team Performance",
                  width = 12,
                  
                  tabPanel(
                    div(style = 'overflow-x: scroll', plotlyOutput("general_teamPlot"))
                  )
                )
              )
            )
    ),
    
    
    # Second tab content
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
                  title = "Stats",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabsetInput",
                  width = 12,
                  
                  tabPanel("Totals",
                           div(style = 'overflow-x: scroll', plotlyOutput("comparePlot1")))
                )
              )
            )
    ),
    
    
    
    tabItem(tabName = "sources",
            h4(
              "All the data is taken from",
              a("NBA.com", href = "https://stats.nba.com/")
            )
    ),
    
    tabItem(
      tabName = "contact",
      h4("Data Science Homework 5 by Mark Hovsepyan"),
      h4("Please feel free to share your comments and/or report any issues."),
      br(),
      h4(
        "Mark Hovsepyan",
        br(),
        a("Email", href = "mailto:markhovsepyan98@gmail.com")
      )
    )
  )
)

ui <- dashboardPage(header, sidebar, body, skin = 'blue')


library(statsnbaR)