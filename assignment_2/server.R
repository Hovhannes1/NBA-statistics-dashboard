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
  
  ## Player shots data
  
  court_image <- reactive({
    courtImg.URL <- "https://thedatagame.files.wordpress.com/2016/03/nba_court.jpg"
    court <- rasterGrob(readJPEG(getURLContent(courtImg.URL)),
                        width=unit(1,"npc"), height=unit(1,"npc"))
    court
  })
  
  
  ### Outputs ###
  
  ## general tab
  
  output$win_percentage <- renderPlotly({
    team_season <- team_season()
    team_win <- as.data.frame(table(team_season$team_abbr))
    
    team_win$win <- team_season %>%
      group_by(team_abbr) %>%
      filter(win == T) %>%
      select(win) %>%
      summarise(cnt = n())
    
    perc <- (team_win$win$cnt / team_win$Freq) * 100
    
    p <- ggplot(team_win, aes(x = reorder(Var1, perc), y = perc)) +
      geom_bar(stat = "identity", aes(fill= Var1)) +
      theme(axis.line = element_blank(),
            axis.text.x = element_blank(),
            axis.ticks = element_blank(),
            legend.position = "none",
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank()) +
      xlab("Teams") +
      ylab("Win Percentage") +
      scale_colour_brewer() +  
      coord_flip() +
      geom_text(size = 3, aes(x = Var1, y = perc + 4 , label = round(perc , 1)))
    
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
    
    compare_data <- player_vs_player()[c(1, 8:21)]
    
    compare_data.long <- melt(compare_data, id.vars = "Player")
    
    player_list <- c(compare_data[1, 1], compare_data[2, 1])
    
    
    p <- ggplot(data = compare_data.long, aes(x = variable, y = value, fill = Player)) +
      geom_bar(data = subset(compare_data.long, Player == player_list[1]), 
               stat = "identity",
               mapping = aes(y = -value),
               position = "identity") + 
      geom_bar(data = subset(compare_data.long, Player == player_list[2]), 
               stat = "identity") +
      scale_y_continuous(breaks=seq(-1500, 1500, 100), labels=abs(seq(-1500, 1500, 100))) +
      coord_flip() +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            legend.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank()) +
      xlab("Player Stats") + ylab(NULL)
    
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
      geom_line(colour = 'rgba(54, 162, 235, 0.5)') + 
      geom_point(aes(fill = one_team_data$win, color = one_team_data$win)) +
      theme(axis.line = element_blank(),
            axis.ticks = element_blank(),
            legend.title = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(),
            panel.background = element_blank()) +
      ylab("Points") +
      xlab("Game date")
    
    ggplotly(p)
  })
  
  
  ## player tab
  
  output$BallR <- renderUI({
    source()
  })
  
  ## data table tab
  output$data_table1 <- DT::renderDataTable({
    DT::datatable(team_season_data(),
                  options = list(lengthMenu = c(5, 30, 50), pageLength = 5))
  })
}
