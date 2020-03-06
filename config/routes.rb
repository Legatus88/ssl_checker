Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    scope module: :v1 do
      get '/status', to: 'ssl_checker#status'
      post '/domain', to: 'ssl_checker#add_domain'
    end
  end
end
