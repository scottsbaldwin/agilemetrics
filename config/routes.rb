Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users

  resources :teams do
	resources :sprints
	match :forecast, to: 'teams#forecast', as: "forecast", via: :post
  end

  match 'averages', to: 'teams#averages', as: "team_averages", via: :get
  match 'checklist', to: 'checklist#index', as: "checklist", via: :get

  root to: 'teams#index'
end
