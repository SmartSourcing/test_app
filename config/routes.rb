Rails.application.routes.draw do

  get  '/game/:id',         to: 'game#play',      as: :game
  post '/game/:id',         to: 'game#played',    as: :game_played
  get  '/game/:id/my_turn', to: 'game#my_turn',   as: :should_i_play_or_should_i_go
  root 'game#index'
end