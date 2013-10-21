Agilemetrics::Application.routes.draw do
  devise_for :users

  resources :teams do
	resources :sprints
  end

  match 'averages', to: 'teams#averages', as: "team_averages", via: :get
  match 'checklist', to: 'checklist#index', as: "checklist", via: :get

  root to: 'teams#index'
end
