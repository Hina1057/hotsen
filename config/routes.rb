Rails.application.routes.draw do
  # 0 トップ
  root "top#index"

  # お客様側
  # セッション（ログイン/ログアウト）
  resource :session, only: [:new, :create, :destroy]

  # 会員（account）
  resources :accounts, path: "account", only: [:new, :create, :show, :edit, :update] do
    member do
      # 1.3 現在の予約情報（予約一覧）
      get :reservations
      delete :destroy
    end
  end

  #faq
  get "/faq", to: "pages#faq"

  # ホテル（一覧・詳細）
  resources :hotels, only: [:index, :show] do
    resources :reservations, only: [:new, :create] do
      collection do
        post :confirm
      end
    end
  end
  

  # 予約キャンセル（予約情報から）
  resources :reservations, only: [:show] do
    member do
      delete :cancel
    end
  end
  

  # お知らせ（閲覧）
  resources :informations, only: [:index, :show]

  # 管理者側

  namespace :admin do
    # 管理者セッション（ログイン/ログアウト）
    resource :session, only: [:new, :create, :destroy]

    # 管理者トップ
    root "top#index"

    # 会員管理（一覧・詳細）
    resources :accounts, only: [:index, :show]

    resources :admins, only: [:index, :new, :create, :edit, :update, :destroy]

    # ホテル管理（一覧・詳細）
    resources :hotels, only: [:index, :show, :new, :create, :edit, :update] do
      resources :rooms, only: [:new, :create, :edit, :update, :destroy]
    end

    # 予約管理（一覧・詳細）
    resources :reservations, only: [:index, :show]

    # お知らせ管理（一覧・追加画面）
    resources :informations, only: [:index, :new, :create, :destroy]
  end
end
