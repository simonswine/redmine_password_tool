RedmineApp::Application.routes.draw do
  get 'projects/:id/password_tool/', :controller => 'password_instances', :action => 'index'
  match 'projects/:id/password_tool/new', :to => 'password_instances#new', :via => [:get, :post], :as => 'new_password_instance'


  #get '/', :controller => 'password_templates' #, :action => 'index'
  resources :password_templates, :only => [:index,:show]
  get 'password_templates/:id/form', :to => 'password_templates#form'
end