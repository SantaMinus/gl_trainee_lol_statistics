Rails.application.routes.draw do
  get 'games/create'
  get 'games/show'

  get "/pages/:page" => "pages#show"
  get "player/:id/update" => "players#update", :as => :update_player
  resources :games
  resources :players

  root "pages#show", page: "home"
end