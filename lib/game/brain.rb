module Game
  class Brain

    @@PLAYERS = [ 'red', 'blue' ]

    def initialize()
      @player_turn = 1
      @game_status = true
      @board = []
    end

    def get_player(player_id)
      @@PLAYERS[player_id-1]
    end
  end
end
