#
# This is the server logic of a Shiny web application.
#


server <- function(input, output, session) {
  
  ## general team data
  
  team_season <- reactive({
    get_teams_by_season(as.numeric(input$seasonInput2))
  })
  
  team_season_data <- reactive({
    get_teams_by_season(as.numeric(input$seasonInput3))
  })
  
  one_team_data <- eventReactive(input$teamSeason_input, {
    get_team_data(team_season(), input$teamInput1)
    
  })
  
  
  ## player comparison data 
  
  player_totals <- reactive({
    get_players_by_season_total(as.numeric(input$seasonInput1))
  })
  
  player_vs_player <- eventReactive(input$compareInput, {
    p1 <- get_player_table(input$player1Input, player_totals())
    p2 <- get_player_table(input$player2Input, player_totals())
    
    rbind(p1, p2)
  })
  
  
  img1 <- eventReactive(input$compareInput, {
    get_pic_link(input$player1Input)
  })
  
  img2 <- eventReactive(input$compareInput, {
    get_pic_link(input$player2Input)
    
  })
  
  info1 <- eventReactive(input$compareInput, {
    pvsp <- player_vs_player()
    age1 <- get_player_age(pvsp[1, ])
    team1 <- get_player_team(pvsp[1, ])
    cbind(team1, age1, row.names = NULL)
  })
  
  info2 <- eventReactive(input$compareInput, {
    pvsp <- player_vs_player()
    age2 <- get_player_age(pvsp[2, ])
    team2 <- get_player_team(pvsp[2, ])
    cbind(team2, age2, row.names = NULL)
  })
  
  
  
  ### Outputs ###
  
  ## general tab
  
  output$win_percentage <- renderPlotly({
    team_season <- team_season()
    team_win <- team_season
    
    p <- ggplot(one_team_data, aes(x = game_date, y = pts)) +
      geom_line(colour = 'rgba(54, 162, 235, 0.5)') + geom_point(aes(fill = one_team_data$win, color = one_team_data$win))
    
    ggplotly(p)
  })
  
  ## team tab
  
  output$teamOutput1 <- renderUI({
    selectInput(inputId = "teamInput1",
                "Select  a team:",
                choices = get_team_list(team_season()))
  })
  
  
  output$teamSeason_output <- renderUI({
    HTML(
      '<center><button id="teamSeason_input" class="btn btn-default action-button">Show</button></center>'
    )
  })
  
  output$general_teamPlot <- renderPlotly({
    one_team_data <- one_team_data()
    one_team_data$win <- ifelse(one_team_data$win, "Win", "Lose")
    
    p <- ggplot(one_team_data, aes(x = game_date, y = pts)) +
      geom_line(colour = 'rgba(54, 162, 235, 0.5)') + geom_point(aes(fill = one_team_data$win, color = one_team_data$win))
    
    ggplotly(p)
  })
  
  
  ## compare tab
  
  output$player1Output <- renderUI({
    selectInput(inputId = "player1Input",
                "Select player 1:",
                choices = get_player_list(player_totals()))
  })
  
  output$player2Output <- renderUI({
    selectInput(inputId = "player2Input",
                "Select player 2:",
                choices = get_player_list(player_totals()))
  })
  
  output$compareOutput <- renderUI({
    HTML(
      '<center><button id="compareInput" class="btn btn-default action-button">Compare</button></center>'
    )
  })
  
  output$player1imgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      img1(),
      '">',
      '</center>')
  })
  
  output$player2imgOutput <- renderText({
    c('<center>',
      '<img height="180" width="120" src="',
      img2(),
      '">',
      '</center>')
  })
  
  output$info1 <- renderTable({
    info1()
  })
  
  output$info2 <- renderTable({
    info2()
  })
  
  
  output$comparePlot1 <- renderPlotly({
    compare_data <- player_vs_player()[, -c(2, 3)]
    compare_data.long <- melt(compare_data, id.vars = "Player")
    
    player_list <- c(compare_data[1, 1], compare_data[2, 1])
    
    
    #p <- ggplot(compare_data.long, aes(x = variable, fill = Player)) + 
     # geom_bar(subset(compare_data.long, Player == player_list[1])) + 
      #geom_bar(subset(compare_data.long, Player == player_list[2]), aes(y = value*(-1))) +
      #coord_flip()
    
    p <- ggplot(data = compare_data.long, aes(x = variable, y = value, fill = Player)) +
      geom_bar(data = subset(compare_data.long, Player == player_list[1]),
               stat = "identity") +
      geom_bar(data = subset(compare_data.long, Player == player_list[2]),
               stat = "identity",
               position = "identity") +
      coord_flip()
    
    ggplotly(p)
  })
  
  ## data table
  output$data_table1 <- DT::renderDataTable({
    DT::datatable(team_season_data(),
                  options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
  
}
