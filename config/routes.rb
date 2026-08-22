Rails.application.routes.draw do
  get "speakers/:slug" => "speakers#show", as: :speaker
  post "speakers/:slug/posts" => "posts#create"
  namespace :families do
    resources :sessions, only: [ :new, :create, :destroy ]
    resources :registrations, only: [ :new, :create ]
    resource :settings, only: [ :show, :update ]
    resources :withdrawals, only: [ :new, :create ]
    post "playbacks/:post_id" => "playbacks#create"
    resources :speakers, only: [ :index, :new, :create, :show, :edit, :update ] do
      resources :posts, only: [ :index ]
      member do
        patch "deactivate"
      end
    end
  end

  get "privacy" => "static_pages#privacy"
  get "terms" => "static_pages#terms"

  root "home#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
