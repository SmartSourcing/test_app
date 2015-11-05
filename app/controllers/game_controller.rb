class GameController < ApplicationController
  layout 'application'

  # Root
  #
  def index
    Thread.current[:game] = nil
  end

  # Access game
  #
  def play

    Thread.current[:game] = Game::Brain.new if !Thread.current[:game].present?

    @game       = Thread.current[:game]
    @player     = @game.get_player params[:id].to_i
    @player_id  = params[:id].to_i
  end

  #= This happens when a player actually plays :)
  #
  def played
    game = Thread.current[:game]
    game.moved(params[:player_id],params[:column],params[:row])

    Thread.current[:game] = game
    render json: { status: 'ok' }
  end
end
