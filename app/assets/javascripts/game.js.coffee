# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.Application ||= {}

# This object manages the different package of lines configurations for a given lottery
class Application.Game
  idle: 0
  game_over: 1
  next_turn: 2
  win: 3

  constructor: (players) ->
    @statuses     = [ 'idle', 'game.over', 'next_turn', 'win' ]
    @matrix       = null
    @rows         = 6
    @columns       = 7
    @status       = 'idle'
    @players      = players
    @current_turn = null
    @new()
    true

  draw:(container) ->

    table = $('<table></table>')
    table.attr('id','game')

    for row_index in [0..@rows-1]
      tr = $('<tr></tr>');
      tr.attr('id',"tr_#{row_index}")
      for column_index in [0..@columns-1]
        td = $('<td width="100" height="100"></td>');
        td.attr('id',"td_#{row_index}_#{column_index}")
        td.html '&nbsp;'
        tr.append(td)
      table.append(tr)

    player = $('<span></span>')
    $(container).append(table)

  new:() ->
    @matrix = []
    for column_index in [0..@columns-1]
      rows = []
      for row_index in [0..@rows-1]
        rows.push ''
      @matrix.push rows
    true

  move:(player,column) ->
    if @status != @statuses[@game_over]

      @current_turn = player
      free_slot = @find_free_slot(column-1)
      if free_slot == -1
        return @statuses[@game_over]

      return @perform_move player,column,free_slot

    else
      return @statuses[@game_over]

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
      return @statuses[@win]
    else
      return @statuses[@next_turn]

  check_horizontal:(player) ->
    return "TODO"

  check_vertical:(player) ->
    vertical_max_iterations  = @columns % 4
    vertical_iteration_index = 0

    for column_index in [0..vertical_max_iterations]
      last_player  = player
      coincidences = 0
      for row_index in [@rows-1..0] by -1
        if @matrix[column_index][row_index] == last_player
          coincidences++
        else
          coincidences = 0
        break if coincidences == 4
      break if coincidences == 4

    if coincidences == 4
      return @statuses[3]
    else
      return @statuses[2]

  check_diagonal:(player) ->
    return "TODO"
