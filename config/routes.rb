Rails.application.routes.draw do

  resources :repositories, except: [:new, :create, :show, :destroy] do
    member do
      get :add
      get :remove
    end
    collection do
      get :refresh
      post :github_callback
    end
  end

  resources :pull_requests do
    patch :resolve, on: :member
    patch :take, on: :member
  end

  root to: 'dashboard#index'

  devise_for :users
  resources :users, only: [:index, :new, :create]
end
