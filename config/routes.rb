Rails.application.routes.draw do

  get "/events", to: "events#index"

  namespace :api do
    namespace :v1 do
      resources :events
      resources :tracking_plans
      post 'tracking_plans/add_events/:id' => 'tracking_plans#add_events'
      get 'tracking_plans/get_events/:id' => 'tracking_plans#get_events'
    end
    # post '/events/create_event' => 'events_api#create_event'
  end
end

