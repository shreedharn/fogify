Shreefogify::Application.routes.draw do
  resources :authentications, :only => [:index, :create]
  resources :albums, :only => [:index]
  resources :fb_albums, :only => [:index]

  resources :pictures
  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout'  }
  match 'auth/:provider/callback' => 'authentications#create'
  root :to => "authentications#index"
end
