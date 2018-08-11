Rails.application.routes.draw do
  # ユーザー画面
  devise_for :users, module: :public, controllers: {
    sessions: 'public/users/sessions',
    passwords: 'public/users/passwords',
  }
  scope '/', module: :public do
    root to: 'home#index'
  end

  # 管理画面
  devise_for :admin_users, path: :admin, controllers: {
    sessions: 'admin/admin_users/sessions',
    passwords: 'admin/admin_users/passwords',
  }
  namespace :admin do
    resources :admin_users do
      collection do
        get :password
        patch :password_update
      end
    end
  end

  # 送信メール (development only)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
