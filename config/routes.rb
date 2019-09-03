Rails.application.routes.draw do
  get 'sessions/new'

 root 'static_pages#home'
 get  '/signup',  to: 'users#new'
 post '/signup',  to: 'users#create'
 get    '/login',   to: 'sessions#new'
 post   '/login',   to: 'sessions#create'
 delete '/logout',  to: 'sessions#destroy'
 get  '/newitem',  to: 'items#new'
 post '/newitem',  to: 'items#create'
 resources :users
 resources :items

end
