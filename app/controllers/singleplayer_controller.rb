class RPS < Sinatra::Base
  
  enable :sessions

  before do
    @player = session[:me]
  end

  post '/singleplayer_game' do
    session[:game] = Game.new
    COMPUTER = Computer.new
    name = params[:name]
    @player = Player.new(name)
    session[:game].add_player(COMPUTER)
    session[:game].add_player(@player)
    session[:me] = @player
    erb :singleplayer_game
  end

  get '/singleplayer_outcome' do
    @computer = session[:game].players[0]
    @player.weapon = params[:weapon].to_sym
    @computer.choose_weapon
    @winner = session[:game].winner
    erb :singleplayer_outcome
  end

  get '/singleplayer_game' do
    erb :singleplayer_game
  end

end