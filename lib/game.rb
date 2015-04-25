class Game

  BEATEN_BY = {Scissors: :Paper, Rock: :Scissors, Paper: :Rock}
  
  def add_player(player)
    players << player
  end

  def players
    @players ||= []
  end

  def reset_game
    @players = []
  end

  def winner
    if @players[0].weapon == @players[1].weapon
      return nil
    elsif @players[0].weapon == BEATEN_BY[@players[1].weapon]
      return @players[1]
    else
      return @players[0]
    end
  end

end