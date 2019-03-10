ActiveAdmin.register Order do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :state, :shipment_state, :uid, :order_number, :shipment_number, :item_total, :shipment_total, :name, :phone, :zipcode, :address1, :address2, :payment_amount, :payment_info, :note, :payment_method, :shipped_at
#
# or
#


controller do
  defaults :finder => :find_by_order_number
end

index do
  selectable_column
  column :order_number
  column :user
  column :name
  column :phone
  column :address1
  column :state
  column :shipment_state
  actions default: true do |obj|
    
    
  end
end

show do
  default_main_content
  panel "Paintings" do
    table_for order.line_items do
      column :state
      column :painting
      column :option
      column :amount
      column :quantity
    end
  end
end


# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
