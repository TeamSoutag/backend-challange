Rails.application.routes.draw do
  root 'refuelings#index'

  resources :users do
    resource :wallet, only: %i[create show update]
  end

  resources :refuelings
  resources :gas_stations
  resources :products
end
