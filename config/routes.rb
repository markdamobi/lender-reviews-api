Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "reviews", to: "reviews#index"
  match "*path", to: "application#catch_routing_error", via: :all
end
