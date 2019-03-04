Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks', registrations: "user/registrations"}

  root to: 'home#index'

  get 'about', to: 'home#about', as: 'about'
  get 'register/info1'
  get 'register/info2'
  post 'register/infoget'

  get 'like/create'
  get 'like/destroy'

  get 'follow/:follower_id/:followed_id', to: 'profiles#follow'
  get 'messages/load_message/:id', to: 'messages#load_message'
  get 'likes/toggle_like/:painting_id', to: 'likes#toggle_like', as: 'toggle_like'
  get 'paintings/search', to: 'paintings#search', as: 'painting_search'

  resources :paintings, :messages, :auctions, :magazines, :magazine_comments, :profiles, :painting_comments, :notices, :options, :faqs

  resources :orders, param: :order_number do
    collection do
      get :cart    
      get :order_list 
      get :cancel_list
      get :cart_cancel
      get :empty_cart
    end
    member do
      get :cancel
      patch :canceling
      patch :request_cancel
      get :pay
      post :paying
      get :complete
    end
  end
  resources :line_items do
    collection do
      post :add_to_cart
      post :direct
    end
  end

end


