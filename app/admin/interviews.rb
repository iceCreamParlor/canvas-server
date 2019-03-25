ActiveAdmin.register Interview do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :web_magazine_id, :question, :answer, :position, :order
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  form(html: { multipart: true }) do |f|
    f.inputs do
      f.input :web_magazine, :as => :select, :collection => WebMagazine.all.collect {|m| [m.number, m.id] }
      f.input :position
      f.input :order
      f.input :question
      f.input :answer
    end
    f.actions
  end

end
