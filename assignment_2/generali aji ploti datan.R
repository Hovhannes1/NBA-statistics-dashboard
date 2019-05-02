players_avg <- players[, 1:6]
players_avg[, 7:8] <- (players[, 7:8] / players[, 6]) * 100
players_avg[, 9:26] <- players[, 9:26] / players[, 6]
