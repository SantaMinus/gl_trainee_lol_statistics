Rails.application.routes.draw do

  get "/pages/:page" => "pages#show"
  resources :games, only: [:index, :show]
  resources :players, except: [:edit, :update] do
    member do
      get 'update' => "players#update_player", :as => :update
    end
  end
  #get "players/:id/update" => "players#update_player", :as => :update_player

  root "pages#show", page: "home"
end