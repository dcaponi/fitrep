Rails.application.routes.draw do
  resources :surveys, except: [:show]
  get '/survey/:uuid', to: 'surveys#show'
  
  resources :ratings
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
