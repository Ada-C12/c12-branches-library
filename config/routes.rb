Rails.application.routes.draw do

  root to: "books#index"

  # The syntax for generating the seven conventional RESTful routes for a given controller are:
  # resources _a symbol of the name of the controller_
  resources :books
  resources :authors do
    # This is equivelant to only: [:index, :new, :create]
    resources :books, shallow: true
  end

  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  # post "/logout", to: "users#logout", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"

  # OAuth support
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"
end
