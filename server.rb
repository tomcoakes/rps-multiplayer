require 'sinatra/base'
require_relative './lib/game'
require_relative './lib/computer'
require_relative './lib/player'

class RPS < Sinatra::Base
  
  enable :sessions

  game = Game.new
  computer = Computer.new

  get '/' do
    erb :index
  end

  get '/singleplayer_register' do
    game.players = []
    erb :singleplayer_index
  end

  get '/multiplayer_register' do
    game.players = []
    erb :multiplayer_index
  end



# SINGLEPLAYER ONLY

post '/singleplayer_game' do
    name = params[:name]
    if name.empty?
      erb :index
    else
      game.players = []
      @player = Player.new(name)
      game.add_player(computer)
      game.add_player(@player)
      erb :singleplayer_game
    end
  end

  get '/singleplayer_outcome' do
    game.players[1].weapon = params[:weapon].to_sym
    game.players[0].choose_weapon
    @computer_weapon = game.players[0].weapon
    @selected_weapon = game.players[1].weapon
    @player = game.players[1]
    @computer = game.players[0]
    @winner = game.winner
    erb :singleplayer_outcome
  end

  get '/singleplayer_game' do
    @player = game.players[1]
    @computer = game.players[0]
    erb :singleplayer_game
  end


# MULTIPLAYER ONLY

  post '/multiplayer_game' do
    name = params[:name]
    if name.empty?
      erb :index
    else
      @player = Player.new(name)
      game.players.empty? ? session[:player_one] = @player : session[:player_two] = @player
      game.add_player(@player)

      while game.players.count < 2 do
        "Waiting for the other player to connect"
      end

      erb :multiplayer_game
    end
  end

  get '/multiplayer_outcome' do
    if session[:player_one]
      game.players[0].weapon = params[:weapon].to_sym
      session[:player_one].weapon = game.players[0].weapon
      @p1_weapon = session[:player_one].weapon
    elsif session[:player_two]
      game.players[1].weapon = params[:weapon].to_sym
      session[:player_two].weapon = game.players[1].weapon
      @p2_weapon = session[:player_two].weapon
    end

    while game.players[0].weapon == nil || game.players[1].weapon == nil do
      "Waiting for the other player to take their turn"
    end

    if session[:player_one]
      @player = game.players[0]
      @opponent = game.players[1]
      @opponents_weapon = game.players[1].weapon
    elsif session[:player_two]
      @player = game.players[1]
      @opponent = game.players[0]
      @opponents_weapon = game.players[0].weapon
    end
    
    @winner = game.winner

      erb :multiplayer_outcome
  end

  get '/multiplayer_game' do
    game.players[0].weapon = nil
    game.players[1].weapon = nil

    if session[:player_one]
      @player = game.players[0]
      @opponent = game.players[1]
    elsif session[:player_two]
      @player = game.players[1]
      @opponent = game.players[0]
    end
    erb :multiplayer_game
  end

  run! if app_file == $0
end
