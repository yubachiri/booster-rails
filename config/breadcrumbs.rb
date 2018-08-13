crumb :admin_users do
  link t('admin.title.admin_users.index'), admin_admin_users_path
end

crumb :admin_user do |admin_user|
  link admin_user.name, admin_admin_user_path
  parent :admin_users
end

crumb :admin do |admin_user|
  link t('admin.actions.edit'), edit_admin_admin_user_path
  parent :admin_user, admin_user
end
