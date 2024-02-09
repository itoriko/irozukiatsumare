Rails.application.routes.draw do
  # ユーザ用
  # URL /users/sign_in ...
  devise_for :users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
  end
end
