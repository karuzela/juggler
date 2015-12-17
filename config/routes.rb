Rails.application.routes.draw do

  resources :repositories, except: [:new, :create] do
    member do
      get :add
      get :remove
      resources :repository_reviewers, only: [] do
        patch :update, on: :collection
      end
    end
    collection do
      get :refresh
      post :github_callback
      post :refresh_webhooks
    end
  end

  resources :pull_requests do
    patch :resolve, on: :member
    patch :take, on: :member
  end

  root to: 'dashboard#index'

  devise_for :users
  resources :users, only: [:index, :new, :create] do
    get 'github_connect', on: :collection
  end
end
