# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    root 'sessions#dev_login'
  else root 'passengers#index'
  end

  resources :users
  resources :passengers
  resources :doctors_notes
  resources :log, except: %i[edit new show]

  unless Rails.env.production?
    get  'sessions/dev_login',
         to: 'sessions#dev_login',
         as: :dev_login
    post 'sessions/dev_login',
         to: 'sessions#dev_login'
  end

  get 'sessions/unauthenticated',
      to: 'sessions#unauthenticated',
      as: :unauthenticated_session
  get 'sessions/destroy',
      to: 'sessions#destroy',
      as: :destroy_session
end
