# frozen_string_literal: true

Rails.application.routes.draw do
  root 'passengers#index'

  resources :feedback, only: %i[index show new create]
  resources :log, except: %i[edit new show]
  resources :mobility_devices, except: :show

  %w[archived pending].each do |status|
    get '/passengers/:status',
        to: 'passengers#index', as: "#{status}_passengers",
        status: /#{status}/, defaults: { status: status }
  end

  resources :passengers do
    collection do
      get :register
      get :brochure
      get :check_existing
    end
    member do
      post :set_status
    end
  end

  resources :users

  unless Rails.env.production?
    get  'sessions/dev_login', to: 'sessions#dev_login', as: :dev_login
    post 'sessions/dev_login', to: 'sessions#dev_login'
  end

  delete 'sessions/destroy', to: 'sessions#destroy', as: :destroy_session
end
