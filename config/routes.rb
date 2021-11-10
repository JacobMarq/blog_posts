Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: 'json' } do
    get '/posts', to: "posts#get_posts"

    get '/ping', to: "ping#ping_api"
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
