Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/register', to: 'users#new'
  get '/dashboard', to: 'users#show'
  get '/discover', to: 'users#discover'

  get '/movies/:id', to: 'movies#show'
  get '/movies', to: 'movies#index'
  
  post '/movies/:id/viewing_party', to: 'viewing_party#create' 
  get '/movies/:id/viewing_party/new', to: 'viewing_party#new'
  resources :users, only: [:create]
end
