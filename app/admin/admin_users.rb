ActiveAdmin.register AdminUser do
  filter :email

  index do
    column :email
    column :phone_number
    default_actions
  end

  show do
    attributes_table :email, :phone_number, :sign_in_count, :current_sign_in_at, :created_at
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :phone_number
    end

    f.buttons
  end
  
end
