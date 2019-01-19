Rails.application.routes.draw do
  get 'register/info1'
  get 'register/info2'
  post 'register/infoget'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks'}
  root to: 'home#index'
  resources :paintings
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
