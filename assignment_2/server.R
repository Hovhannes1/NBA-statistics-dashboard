#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#


server <- function(input, output, session) {
  
  player_totals <- reactive({
    get_players_by_season_total(as.numeric(input$seasonInput1))
  })
  
  main_totals_1 <- eventReactive(input$compareInput, {
    get_player_table(input$player1Input, player_totals())
  })
  
  main_totals_2 <- eventReactive(input$compareInput, {
    get_player_table(input$player2Input, player_totals())
  })
  
  img1 <- eventReactive(input$compareInput, {
    get_pic_link(input$player1Input)
  })
  
  img2 <- eventReactive(input$compareInput, {
    get_pic_link(input$player2Input)
    
  })
  
  info1 <- eventReactive(input$compareInput, {
    age1 <- get_player_age(main_totals_1())
    team1 <- get_player_team(main_totals_1())
    cbind(team1, age1, row.names = NULL)
  })
  
  info2 <- eventReactive(input$compareInput, {
    age2 <- get_player_age(main_totals_2())
    team2 <- get_player_team(main_totals_2())
    cbind(team2, age2, row.names = NULL)
  })
  
  ## team data
  team_season <- reactive({
    get_teams_by_season(as.numeric(input$seasonInput2))
  })
  
  one_team_data <- eventReactive(input$teamInput1, {
    get_team_data(team_season(), input$team_season1)
    
  })
  
  
  ## Outputs
  
  output$teamOutput1 <- renderUI({
    selectInput(inputId = "teamInput1",
                "Select  a team:",
                choices = get_team_list(get_teams_by_season()))
  })
  
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
  
  output$team_ptsOutput <- renderUI({
    HTML(
      '<center><button id="teamInput1" class="btn btn-default action-button">Show</button></center>'
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
    compare_data <- rbind(main_totals_1(), main_totals_2())
    compare_data.long <- melt(compare_data, id.vars = "Player")
    
    p <- ggplot(compare_data.long, aes(x = variable, y = value, fill = Player)) +
      geom_bar(stat = "identity", position = "dodge")
    
    ggplotly(p)
  })
  
  output$general_teamPlot <- renderPlotly({
    one_team_data <- one_team_data()
    
    p <- ggplot(one_team_data, aes(x = game_date, y = pts, fill = win)) +
      geom_bar()
    
    ggplotly(p)
  })
  
  
}
