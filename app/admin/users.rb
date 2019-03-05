ActiveAdmin.register User do

  member_action :import, :method=>:post do
    
  end

  permit_params :email, :nickname, :image, :desc, :instagram, :user_type
  index :as => :table do
    column :email
    column :user_type
    column :nickname
    # column :instagram
    column() {|user| link_to "#{ user.instagram }", user.instagram if user.instagram.present? }
    
    actions do |user|
      link_to "작가승인", accept_seller_profile_path(user), remote: "true"
    end

end


end
