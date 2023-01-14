Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'dashboard#index'
  get 'dashboard/index'

  namespace :accounts do
    resources :account_imports, only: %i[index create]
    resources :daily_transaction_imports, only: %i[index create]
  end
end
