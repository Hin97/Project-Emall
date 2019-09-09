Rails.application.routes.draw do

  get 'payment/show'

  get 'sessions/new'

 root 'static_pages#home'
 get  '/signup',  to: 'users#new'
 post '/signup',  to: 'users#create'
 get    '/login',   to: 'sessions#new'
 post   '/login',   to: 'sessions#create'
 delete '/logout',  to: 'sessions#destroy'
 get  '/newitem',  to: 'items#new'
 post '/newitem',  to: 'items#create'
 get '/newtrade', to: 'trades#new'
 post '/newtrade', to: 'trades#create'
  get  '/newpayment',  to: 'payments#new'
 post '/newpayment',  to: 'payments#create'
 resources :users
 resources :items
 resources :trades
 

end
