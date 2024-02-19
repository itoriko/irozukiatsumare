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
    resources :posts
    resources :colors# [:index, :create, :edit, :update, :destroy]
    resources :users, only: [:index, :show, :edit, :update, :destroy]
  end

  scope module: :public do
    root to: "homes#top"
    get '/search', to: 'searches#search'

    resources :users do
      resource :relationships, only: [:create, :destroy]
    	  get "followings" => "relationships#followings", as: "followings"
    	  get "followers" => "relationships#followers", as: "followers"
      collection do
        get 'users/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'
        patch 'users/withdraw', to: 'users#withdraw', as: 'withdraw'
      end
    end
    resources :colors, only: [:index, :create, :edit, :show, :update, :destroy] do
      resources :posts, only: [:create, :new]
    end
    resources :posts, only: [:index, :edit, :show, :update, :destroy] do
      resource :favorite, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
  end
end
