Rails.application.routes.draw do
  get 'games/create'

  get 'games/show'

  resources :banned_champions
  resources :games
  resources :players

  root 'players#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end