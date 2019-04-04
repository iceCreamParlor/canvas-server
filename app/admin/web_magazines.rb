ActiveAdmin.register WebMagazine do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
  permit_params :web_magazine_group_id, :number, :image, :artist_name, :brief, :content1, :content2

  index :as => :table do

    
    selectable_column
    id_column
    column :web_magazine_group
    column :number
    column :artist_name
    
    actions 
  end

end
