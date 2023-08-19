Rails.application.routes.draw do

  get "/events", to: "events#index"

  namespace :api do
    namespace :v1 do
      resources :events
      resources :tracking_plans
    end
    # post '/events/create_event' => 'events_api#create_event'
  end
end

