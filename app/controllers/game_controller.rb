class GameController < ApplicationController
  layout 'application'

  # Root
  #
  def index
  end

  # Access game
  #
  def play

    Thread.current[:game] = Game::Brain.new if !Thread.current[:game].present?

    @game   = Thread.current[:game]
    @player = @game.get_player params[:id].to_i
  end
end
