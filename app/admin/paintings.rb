ActiveAdmin.register Painting do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  permit_params :name, :status, :price, :category_id, :color_id, :thumbnail, :desc, :completed_date, { images: [] }

  form(html: { multipart: true }) do |f|
    f.inputs do
      f.input :name
      f.input :price
      f.input :status
      f.input :category, :as => :select, :collection => Category.all.collect {|category| [category.name, category.id] }
      f.input :color, :as => :select, :collection => Color.all.collect {|color| [color.name, color.id] }
      f.input :desc
      f.input :completed_date
      f.label :thumbnail
      f.file_field :thumbnail
      f.label :images
      f.file_field :images, multiple: true
    end
    f.actions
  end

end
