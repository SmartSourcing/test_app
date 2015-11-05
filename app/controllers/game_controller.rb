class GameController < ApplicationController
  layout 'application'
  before_filter :load_game, except: [:index]
  after_filter :save_game

  # Root
  #
  def index
    @game = Game::Brain.new
  end

  # Access game
  #
  def play
    player_id   = params[:id].to_i
    @player     = @game.get_player player_id
    @player_id  = params[:id].to_i
  end

  #= Checks if the player can player
  #
  def my_turn
    player_id = params[:id].to_i

    puts "player #{player_id}"
    puts "game : #{@game.player_turn}"
    puts "turn is: #{(@game.player_turn.to_i == player_id.to_i)}"
    render json: { status: 'ok', data: (@game.player_turn.to_i == player_id.to_i) , blocks: @game.board_moves }
  end

  #= This happens when a player actually plays :)
  #
  def played
    player_id = params[:id].to_i

    @game.moved(player_id,params[:column],params[:row])
    puts "turno de: #{@game.player_turn}"
    render json: { status: 'ok' }
  end

  protected

  def load_game
    @game = Rails.cache.fetch("game")
  end

  def save_game
    Rails.cache.write("game", @game)
  end
end
