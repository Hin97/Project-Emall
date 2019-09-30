Rails.application.routes.draw do

  get 'categories/new'
  get 'categories/show'
 
  get 'payment/show'
  get 'search', to: 'items#search'
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
 get '/purchased', to: "trades#purchased"
 get '/sold', to: "trades#sold"
 get  '/newpayment',  to: 'payments#new'
 post '/newpayment',  to: 'payments#create'
 get '/updatetrade', to: 'trades#edit'
 post '/updatetrade', to: 'trades#update'
 
 resources :users
 resources :items
 resources :trades
 resources :categories
 

end
