Rails.application.routes.draw do
  
  get 'like/create'
  get 'like/destroy'
  mount Ckeditor::Engine => '/ckeditor'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { omniauth_callbacks: 'user/omniauth_callbacks', registrations: "user/registrations"}

  root to: 'home#index'
  get 'register/info1'
  get 'register/info2'
  post 'register/infoget'

  get 'follow/:follower_id/:followed_id', to: 'profiles#follow'
  get 'messages/load_message/:id', to: 'messages#load_message'
  get 'likes/toggle_like/:painting_id', to: 'likes#toggle_like', as: 'toggle_like'

  resources :paintings, :messages
  resources :magazines
  resources :magazine_comments
  
  resources :profiles do 
    member do 
      
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
