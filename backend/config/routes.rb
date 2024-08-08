Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :flair_templates, only: [:index, :show]
  resources :comments, only: [:index, :show]
  resources :submissions, only: [:index, :show]
  resources :redditors, only: [:index, :show]
  resources :subreddits, only: [:index, :show]
  resources :subreddit_redditors, only: [:index, :show]
  resources :removal_reasons, only: [:index, :show]
  resources :reports, only: [:index, :show]
end
