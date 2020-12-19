Rails.application.routes.draw do
  resources :events
  root "welcome#index"
  get "/auth/:provider/callback" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  resources :retirements, only: %i(new create)

  resources :events, only: %i(new create show edit update destroy) do
    resources :tickets, only: %i(new create destroy)
  end

  get '/status' => 'status#index', defaults: { format: 'json' }

  # エラーハンドリング用のURLキャッチ
  match "*path" => "application#error404", via: :all
end