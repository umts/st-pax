Rails.application.routes.draw do
  get 'sessions/new'
  resources :users
  root 'passengers#index'
  resources :passengers
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
