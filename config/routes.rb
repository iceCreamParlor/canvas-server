Rails.application.routes.draw do

  resources :faqs
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

  resources :paintings, :messages, :auctions, :magazines, :magazine_comments, :profiles, :painting_comments, :notices

end


