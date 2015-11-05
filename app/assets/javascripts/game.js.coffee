# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Application ||= {}

# This object manages the different package of lines configurations for a given lottery
class Application.Game

  constructor: (players) ->
    @statuses = [ 'game.finished', 'game.over', 'next_turn', 'win' ]
    @matrix = nil
    @rows   = 6
    @cols   = 7
    @status = 'idle'
    @new()
    @players = players
    true

  new:() ->
    @matrix = []
    for column_index in [0..@columns-1]
      rows = []
      for row_index in [0..@rows-1]
        rows.push ''
      @maxtrix.push rows
    true

  move:(player,column) ->
    if @status != 'idle'

      free_slot = @find_free_slot(column-1)
      if free_slot == -1
        return @statuses[1]

      return @perform_move player,column,free_slot

    else
      return @statuses[0]

  find_free_slot:(column) ->
    rows = @matrix[column]
    for row in rows
      if @matrix[column][row] == ''
        return row

    return -1

  perform_move:(player,column,free_slot) ->
    @matrix[column][free_slot] = player
    return @check_for_win(player)

  @check_for_win:(player) ->
    if @check_horizontal(player) || @check_vertical(player) || @check_diagonal(player) == true
      return @statuses[3]
    else
      return @statuses[2]

  check_horizontal:(player) ->
    return "TODO"

  check_vertical:(player) ->
    return "TODO"

  check_diagonal:(player) ->
    return "TODO"
