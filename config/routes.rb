Rails.application.routes.draw do

  resources :repositories do
    member do
      post 'add'
      post 'remove'
    end
    collection do
      get 'refresh'
    end
  end

  root to: 'dashboard#index'

  devise_for :users
end
