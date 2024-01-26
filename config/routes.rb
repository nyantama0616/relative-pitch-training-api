Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/interval_rates", to: "train_records#interval_rates"
  post "/signin", to: "sessions#create"
  post "/signup", to: "users#create"

  resources :train_records, only: [:index, :show, :create]
  resources :users, only: [:index, :show, :create]
  
  get "/images/:image_path", to: "images#show"

  get "/questionnaires/:name", to: "questionnaires#show"
  post "/questionnaires", to: "questionnaires#create"

  get "/train_records/:id/means", to: "train_records#means"

  #なんとなくnamespaceで分けてみた
  namespace :test do
    get "ping", to: "tests#ping"
    get "ping_with_message", to: "tests#ping_with_message"
    post "greet", to: "tests#greet"
  end
end
