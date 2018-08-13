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

crumb :users do
  link t('admin.title.users.index'), admin_users_path
end

crumb :new_user do |user|
  link t('admin.actions.new'), new_admin_user_path
  parent :users
end

crumb :user do |user|
  link user.email, admin_user_path
  parent :users
end

crumb :edit_user do |user|
  link t('admin.actions.edit'), edit_admin_user_path
  parent :user, user
end
