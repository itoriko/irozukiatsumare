Rails.application.routes.draw do
  namespace :public do
    get 'uers/show'
    get 'uers/edit'
    get 'uers/unsubscribe'
  end
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

  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
  end

  scope module: :public do
    root to: "homes#top"
    get 'users/my_page' => 'users#show'
    get 'users/infomation/edit' => 'users#edit'
    patch 'users/information' => 'users#update'
    get 'users/unsubscribe' => 'users#unsubscribe'
    patch 'users/withdraw' => 'users#withdraw'
  end
end
