Rails.application.routes.draw do
  resources :rating_links, except: [:show]
  get '/rating_link/:uuid', to: 'rating_links#show'
  
  resources :ratings
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
