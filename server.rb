require 'sinatra/base'
require_relative './lib/game'
require_relative './lib/computer'
require_relative './lib/player'

class RPS < Sinatra::Base
  
  enable :sessions

  GAME = Game.new
  COMPUTER = Computer.new

  get '/' do
    erb :index
  end

  get '/singleplayer_register' do
    GAME.players = []
    erb :singleplayer_index
  end

  get '/multiplayer_register' do
    GAME.players = []
    erb :multiplayer_index
  end



# SINGLEPLAYER ONLY

  post '/singleplayer_game' do
    name = params[:name]
    if name.empty?
      erb :singleplayer_index
    else
      GAME.players = []
      @player = Player.new(name)
      GAME.add_player(COMPUTER)
      GAME.add_player(@player)
      session[:me] = @player.object_id
      erb :singleplayer_game
    end
  end

  get '/singleplayer_outcome' do
    @player = GAME.players.select { |player| player.object_id == session[:me] }.first
    @computer = GAME.players.select { |player| player.object_id != session[:me] }.first
    @player.weapon = params[:weapon].to_sym
    @computer.choose_weapon
    erb :singleplayer_outcome
  end

  get '/singleplayer_game' do
    @player = GAME.players.select { |player| player.object_id == session[:me] }.first
    @computer = GAME.players.select { |player| player.object_id != session[:me] }.first
    erb :singleplayer_game
  end


# MULTIPLAYER ONLY

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

  run! if app_file == $0
end
