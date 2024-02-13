Rails.application.routes.draw do

  # ユーザ用
  # URL /users/sign_in ...
  devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin,skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  # ゲストログイン用ルーティング
  devise_scope :user do
  post "users/guest_sign_in", to: "public/sessions#guest_sign_in", as: 'guest_sign_in'
  end

  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
  end

  scope module: :public do
    root to: "homes#top"
    resources :users do
      collection do
        get 'users/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
        patch 'users/withdraw', to: 'users#withdraw', as: 'withdraw'
      end
    end
  end
end
