Shreefogify::Application.routes.draw do
  resources :authentications

  match 'auth/:provider/callback' => 'authentications#create'
  
  devise_for :users, :path => "auth", :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'register', :sign_up => 'cmon_let_me_in' }
  
  resources :pictures
  resources :albums
  root :to => "albums#index"

 
end
