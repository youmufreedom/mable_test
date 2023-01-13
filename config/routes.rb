Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root 'accounts#index'
  resources :accounts, only: %i[index]

  namespace :accounts do
    resources :imports, controller: 'imports', only: %i[index create]
    resources :daily_transaction_imports, controller: 'daily_transaction_imports', only: %i[index create]
  end
end
