Rails.application.routes.draw do
  get 'games/create'
  get 'games/show'

  get "/pages/:page" => "pages#show"

  resources :banned_champions
  resources :games
  resources :players

  root 'players#index'
  #root "pages#show", page: "home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end