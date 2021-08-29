Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  get '/registration', to: 'users#new'
  post '/registration', to: 'users#create'

  get '/dashboard', to: 'users#show'

  post '/login', to: 'sessions#create'

  get '/discover', to: 'movies#discover'

  get '/movies', to: 'movies#index'

  post '/friendships', to: 'friendships#create'
end
