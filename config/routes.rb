Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # /login
  post '/login', to: 'sessions#login'

  # /users
  resources :users, only: [:index, :create] do
    collection do
      # GET /users/followings
      get 'followings'
      # GET /users/followers
      get 'followers'
    end
    # /users/:id
    member do
      post 'follow'
      delete 'unfollow'
    end
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
