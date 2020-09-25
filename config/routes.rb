# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    root 'sessions#dev_login'
  else root 'passengers#index'
  end

  resources :feedback, only: %i[index show new create]
  resources :log, except: %i[edit new show]
  resources :mobility_devices, except: :show
  resources :passengers do
    collection do
      get :new_or_edit_registration
      get :brochure
      get :archived
      get :check_existing
      get :pending
    end
    member do
      post :set_status
    end
  end
  resources :users

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
