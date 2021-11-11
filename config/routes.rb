Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    get '/posts', to: "posts#get_posts"

    get '/ping', to: "ping#ping_api"
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
