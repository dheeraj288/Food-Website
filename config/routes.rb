Rails.application.routes.draw do
  namespace :customers do
    get 'restaurants/index'
    get 'restaurants/show'
  end
  root 'home#index'
  devise_for :users, controllers: {
              sessions: 'users/sessions',
              registrations: 'users/registrations'
            }
            
  get 'admin_dashboard', to: 'dashboards#admin'
  get 'owner_dashboard', to: 'dashboards#owner'
  get 'customer_dashboard', to: 'dashboards#customer'

  get 'otp_verification', to: 'otp#new'
  post 'otp_verify', to: 'otp#verify'
  get "resend_otp", to: "otp#resend", as: :resend_otp

  resources :restaurants do
  resources :menu_items, except: [:index, :show]
  resources :reviews, only: [:create, :destroy]
end

resource :cart, only: [:show]
resources :cart_items, only: [:create, :update, :destroy]
resources :orders, only: [:index, :show, :create]

namespace :customers do
  resources :restaurants, only: [:index, :show]
end

  post 'payments', to: 'payments#create'
  post 'payments/elements', to: 'payments#elements'
  get 'payments/success', to: 'payments#success'
  get 'payments/cancel', to: 'payments#cancel'

  get "up" => "rails/health#show", as: :rails_health_check
 
end

