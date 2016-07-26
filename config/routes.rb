Rails.application.routes.draw do
  resources :banned_champions
  resources :games
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/destroy'

  resources :players
  #get 'admin/index'

  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  get "sessions/create"
  get "sessions/destroy"

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  get '/signup' => 'users#new'
  post '/users' => 'users#create'

  resources :users

  root 'players#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end