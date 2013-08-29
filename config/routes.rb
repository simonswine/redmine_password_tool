RedmineApp::Application.routes.draw do
  get 'projects/:id/password_tool/', :controller => 'password_instances', :action => 'index'
  get 'projects/:id/password_tool/new', :controller => 'password_instances', :action => 'new'

  #get '/', :controller => 'password_templates' #, :action => 'index'
  resources :password_templates, :only => [:index,:show]
  get 'password_templates/:id/form', :to => 'password_templates#form'
end