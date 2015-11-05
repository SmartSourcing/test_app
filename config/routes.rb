Rails.application.routes.draw do

  get '/game/:id', to: 'game#play', as: :game
  root 'game#index'
end