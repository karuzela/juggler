Rails.application.routes.draw do
  root to: 'dashboard#index'

  post "/github/synchronize_repositories" => "github_integration#synchronize_repositories", as: :synchronize_repositories
  post "/github/synchronize_webhooks" => "github_integration#synchronize_webhooks", as: :synchronize_webhooks
  post "/repositories/github_callback" => "webhooks#callback", as: :webhook

  resources :repositories, except: [:new, :create] do
    get :add, on: :member
    get :remove, on: :member
  end

  resources :pull_requests do
    patch :resolve, on: :member
    patch :take, on: :member
  end

  devise_for :users
  resources :users, only: [:index, :new, :create] do
    get 'github_connect', on: :collection
  end
end
