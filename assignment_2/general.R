teams <- as.data.frame(table(a$team_abbr))

teams$win <- a %>%
  group_by(team_abbr) %>%
  filter(win == T) %>%
  select(win) %>%
  summarise(cnt = n())

ggplot(teams, aes(x = reorder(Var1, ((win$cnt / Freq) * 100)), y = (win$cnt / Freq) * 100 )) +
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
  geom_text(aes(x = Var1, y = (win$cnt / Freq) * 100 + 3 , label = round((win$cnt / Freq) * 100 , 1)))


player <- get_player_table("Lebron James", players)
players_new <- player[c(1, 8:21)]
  
  
  
  
  
  