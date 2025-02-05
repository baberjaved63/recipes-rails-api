require 'sidekiq/web'

module ActionDispatch
  module Routing
    class Mapper
      def draw(routes_name)
        routes_path = Rails.root.join('config', 'routes', (@scope[:shallow_prefix]).to_s, "#{routes_name}.rb")

        instance_eval(File.read(routes_path))
     end
    end
  end
end

Rails.application.routes.draw do
use_doorkeeper
      mount Rswag::Ui::Engine => '/api-docs'
      mount Rswag::Api::Engine => '/api-docs'
  get '/health' => 'pages#health_check'

  namespace :api do
    put '/users_passwords', to: 'users_passwords#put_users_passwords'
    resources :users_registrations, only: [:create]
    resources :users_verify_reset_password_requests, only: [:create]
    resources :users_reset_password_requests, only: [:create]
    resources :users_sessions, only: [:create]
    resources :ingredients, only: [:index, :create, :show, :update, :destroy] do
      collection do
        get :weight_convertor
      end
    end
    resources :categories, only: [:index, :create, :show, :update, :destroy]
    resources :recipes, only: [:index, :create, :show, :update, :destroy]
  end

  # jitera-anchor-dont-touch: webhooks

  namespace :dashboard do
    # TODO: customizable table name
  end

  unless Rails.env.development?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      admin_username = ENV['SIDEKIQ_DASHBOARD_USERNAME']
      admin_password = ENV['SIDEKIQ_DASHBOARD_PASSWORD']
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(admin_username)
      ) && ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(admin_password)
      )
    end
  end
  mount Sidekiq::Web => '/sidekiq'
end
