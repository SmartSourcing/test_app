module Game
  class Brain

    attr_reader :player_turn
    attr_reader :game_status
    attr_reader :board_moves

    @@AVAILABLE_PLAYERS = [1,2]
    @@PLAYERS_COLORS    = [ 'red', 'blue' ]

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

      @board_moves << { player_id: @@PLAYERS_COLORS[player_id-1], column: column, row: row }

      if player_id == @@AVAILABLE_PLAYERS[@@AVAILABLE_PLAYERS.count-1]

        puts "case.1"
        @player_turn = @@AVAILABLE_PLAYERS[0]
      else

        puts "case.2"
        @player_turn = player_id + 1
      end
    end
  end
end
