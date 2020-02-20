Rails.application.routes.draw do
  
  root "welcome#home"
  get '/login', to: "sessions#new"
  post '/login', to: "sessions#create"
  post '/logout', to: "sessions#destroy"
  get '/signup', to: "hosts#new"
  get '/auth/:provider/callback', to: 'sessions#create'

  resources :hosts do
    resources :shows do
      resources :interviews
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
