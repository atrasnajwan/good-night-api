Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # /login
  post '/login', to: 'sessions#login'

  # /users
  resources :users, only: [:index, :show, :create] do
    # GET /users/:user_id/sleep_records
    get 'sleep_records', to: 'sleep_records#user_sleep_records' 
  end

  # /sleep_records
  resources :sleep_records, only: [:index] do
    # /sleep_records/:id/clock_out
    patch 'clock_out', on: :member
  end

  # POST /sleep_records
  post '/sleep_records', to: 'sleep_records#clock_in'
end
