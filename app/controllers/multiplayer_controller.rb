class RPS < Sinatra::Base
  
  enable :sessions

  GAME = Game.new

  post '/multiplayer_game' do
    name = params[:name]
    if name.empty?
      erb :multiplayer_index
    else
      @player = Player.new(name)
      GAME.players.empty? ? session[:player_one] = @player : session[:player_two] = @player
      GAME.add_player(@player)

      while GAME.players.count < 2 do
        "Waiting for the other player to connect"
      end

      erb :multiplayer_game
    end
  end

  get '/multiplayer_outcome' do
    if session[:player_one]
      GAME.players[0].weapon = params[:weapon].to_sym
      session[:player_one].weapon = GAME.players[0].weapon
      @p1_weapon = session[:player_one].weapon
    elsif session[:player_two]
      GAME.players[1].weapon = params[:weapon].to_sym
      session[:player_two].weapon = GAME.players[1].weapon
      @p2_weapon = session[:player_two].weapon
    end

    while GAME.players[0].weapon == nil || GAME.players[1].weapon == nil do
      "Waiting for the other player to take their turn"
    end

    if session[:player_one]
      @player = GAME.players[0]
      @opponent = GAME.players[1]
      @opponents_weapon = GAME.players[1].weapon
    elsif session[:player_two]
      @player = GAME.players[1]
      @opponent = GAME.players[0]
      @opponents_weapon = GAME.players[0].weapon
    end
    
    @winner = GAME.winner

      erb :multiplayer_outcome
  end

  get '/multiplayer_game' do
    GAME.players[0].weapon = nil
    GAME.players[1].weapon = nil

    if session[:player_one]
      @player = GAME.players[0]
      @opponent = GAME.players[1]
    elsif session[:player_two]
      @player = GAME.players[1]
      @opponent = GAME.players[0]
    end
    erb :multiplayer_game
  end

end