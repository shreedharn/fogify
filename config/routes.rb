Shreefogify::Application.routes.draw do
  devise_for :users

  resources :pictures
  resources :albums
  root :to => "albums#index"

 
end
