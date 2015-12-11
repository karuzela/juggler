Rails.application.routes.draw do

  resources :repositories do
    member do
      get 'add'
      get 'remove'
    end
    collection do
      get 'refresh'
    end
  end

  resources :pull_requests do
    patch :take, on: :member
  end

  root to: 'dashboard#index'

  devise_for :users
  resources :users, only: [:index, :new, :create]
end
