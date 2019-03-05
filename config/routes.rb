Rails.application.routes.draw do

  get 'like/create'
  get 'like/destroy'
  mount Ckeditor::Engine => '/ckeditor'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks', registrations: "user/registrations"}

  root to: 'home#index'
  get 'about', to: 'home#about', as: 'about'
  get 'register/info1'
  get 'register/info2'
  post 'register/infoget'

  get 'follow/:follower_id/:followed_id', to: 'profiles#follow'
  get 'messages/load_message/:id', to: 'messages#load_message'
  get 'likes/toggle_like/:painting_id', to: 'likes#toggle_like', as: 'toggle_like'
  get 'paintings/search', to: 'paintings#search', as: 'painting_search'

  resources :paintings, :messages, :auctions, :magazines, :magazine_comments, :painting_comments, :notices, :faqs

  # resources :register_sellers, only: [:new, :create, :destroy]

  resources :profiles do
    collection do
      get :register_sellers
      post :register_sellers, to: "profiles#create_register_sellers", as: "create_register_sellers"
    end
    member do
      get :accept_seller, to: "profiles#accept_seller", as: "accept_seller"
      get :cancel_seller, to: "profiles#cancel_seller", as: "cancel_seller"
    end
  end

end


