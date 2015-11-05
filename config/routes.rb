Rails.application.routes.draw do

  get  '/game/:id', to: 'game#play', as: :game
  post '/game/:id', to: 'game#played', as: :game_played
  root 'game#index'
end