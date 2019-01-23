Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks', registrations: "user/registrations"}

  root to: 'home#index'
  get 'register/info1'
  get 'register/info2'
  post 'register/infoget'

  get 'follow/:follower_id/:followed_id', to: 'profiles#follow'
  
  resources :paintings
  resources :messages
  resources :profiles
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
