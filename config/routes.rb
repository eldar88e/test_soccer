Rails.application.routes.draw do
  resources :statistics, only: [:index]
  resources :matches, only: [:create]

  root "statistics#index"
end
