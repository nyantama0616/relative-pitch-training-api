Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/interval_rates", to: "train_records#interval_rates"
  resources :train_records, only: [:create]
  resources :users, only: [:index, :show, :create]

  #なんとなくnamespaceで分けてみた
  namespace :test do
    get "ping", to: "tests#ping"
    get "ping_with_message", to: "tests#ping_with_message"
    post "greet", to: "tests#greet"
  end
end
