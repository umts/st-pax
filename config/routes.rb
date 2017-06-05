Rails.application.routes.draw do
  resources :users
  root 'passengers#index'
  resources :passengers
end
