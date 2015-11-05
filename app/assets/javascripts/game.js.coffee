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

  constructor: (players,player,player_id) ->
    @statuses     = [ 'idle', 'game.over', 'next_turn', 'win' ]
    @matrix       = null
    @rows         = 6
    @columns      = 7
    @status       = 'idle'
    @players      = players
    @player       = player
    @player_id    = player_id
    @current_turn = ( player_id == 1 )
    @new()
    @interval_handler = setInterval @check_turn, 5000
    true

  draw:(container) ->
    me = @
    table = $('<table></table>')
    table.attr('id','game')

    for row_index in [0..@rows-1]
      tr = $('<tr></tr>');
      tr.attr('id',"tr_#{row_index}")
      for column_index in [0..@columns-1]
        td = $('<td width="100" height="100"></td>');
        td.attr 'id',"td_#{row_index}_#{column_index}"
        td.attr 'row',row_index
        td.attr 'col',column_index
        td.html '&nbsp;'
        td.bind 'click', () ->
          me.clicked(this)

        tr.append(td)
      table.append(tr)

    player = $('<span></span>')
    $(container).append(table)

  clicked:(sender) ->
    if !@current_turn
      alert 'Espere su turno'
      return

    column  =  $(sender).attr 'col'
    @play column
    return

  new:() ->
    @matrix = []
    for column_index in [0..@columns-1]
      rows = []
      for row_index in [0..@rows-1]
        rows.push ''
      @matrix.push rows
    true

  play:(column) ->
    if @status != @statuses[@game_over]

      @current_turn = @player
      free_slot = @find_free_slot(column)
      if free_slot == -1
        return @game_over()
      return @perform_move @player,column,free_slot
    else
      return @game_over()

  game_over:() ->
    clearTimeout @interval_handler
    return @statuses[@game_over]

  find_free_slot:(column) ->
    rows = @matrix[column]
    row_index = 0
    for row_index in [@rows-1..0] by -1
      if @matrix[column][row_index] == ''
        return row_index
      row_index++

    return -1

  perform_move:(player,column,free_slot) ->
    @matrix[column][free_slot] = player
    td = $("#td_#{free_slot}_#{column}")
    td.attr 'bgcolor',player
    @sync column,free_slot

    return @check_for_win(player)

  check_for_win:(player) ->
    return false
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

  sync:(column,row) ->
    me = @
    $.ajax
      method: 'post'
      url: "/game/#{@player_id}"
      data: { player_id: @player_id, column: column ,row: row}
      dataType: "json"
      error: (jqXHR, textStatus, errorThrown) ->
        me.current_turn = true
      success: (data) ->
        me.current_turn = false
    return

  check_turn:() ->
    if game.current_turn == false
      $.ajax
        method: 'get'
        url: "/game/#{game.player_id}/my_turn"
        dataType: "json"
        error: (jqXHR, textStatus, errorThrown) ->
          alert(textStatus)
        success: (data) ->
          game.current_turn = data['data']
          game.re_draw(data['blocks'])
    return

  clear_board:() ->
    $('#game').find('td').each (index, element) ->
      $(element).attr 'bgcolor','white'
    return

  re_draw:(data) ->
    me = @
    @clear_board()
    for block in data
      $("#td_#{block.row}_#{block.column}").attr('bgcolor',block.player_id)
      me.matrix[block.column][block.row] = block.player

    return