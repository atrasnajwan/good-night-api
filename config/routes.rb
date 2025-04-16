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
  resources :sleep_records, only: [:index]
  
  namespace :sleep_records do 
    # /sleep_records/clock_in
    post 'clock_in'
    # /sleep_records/clock_out
    patch 'clock_out'
  end

end
