Shreefogify::Application.routes.draw do
  resources :pictures
  resources :albums
  root :to => "albums#index"

 
end
