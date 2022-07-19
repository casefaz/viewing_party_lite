Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'
  get '/register', to: 'users#new'
  get '/dashboard', to: 'users#show'
  get '/discover', to: 'users#discover'
  get '/movies/:id', to: 'movies#show'
  resources :users, only: [:create] do
    resources :movies, only: [:index] do
      resources :viewing_party, only: [:new, :create]
    end
  end
end
