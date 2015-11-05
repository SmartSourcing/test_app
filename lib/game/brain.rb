module Game
  class Brain

    attr_reader :player_turn
    attr_reader :game_status
    attr_reader :board_clicks

    @AVAILABLE_PLAYERS = [1,2]
    @@PLAYERS_COLORS   = [ 'red', 'blue' ]

    def initialize()
      @player_turn  = 1
      @game_status  = true
      @board_moves  = []
    end

    #= Returns the color of a player given its ID
    #
    def get_player(player_id)
      @@PLAYERS_COLORS[player_id-1]
    end

    #= Records a move an pass the turn to the other player
    def moved(player_id,column,row)

      @board_moves << { player_id: player_id, column: column, row: row }

      if player_id = @AVAILABLE_PLAYERS.last()

        @player_turn = @AVAILABLE_PLAYERS.firt()
      else

        @player_turn = player_id + 1
      end
    end
  end
end
