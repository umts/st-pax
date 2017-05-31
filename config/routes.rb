Rails.application.routes.draw do
  root 'passengers#index'
  resources :passengers
end
