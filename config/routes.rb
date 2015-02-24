# Instances
resources :projects do
  resources :password_instances, shallow: true
end
match 'password_instances/:id/data_schema', :to => 'password_instances#data_schema', :via => [:get]


resources :password_templates, :only => [:index,:show]
get 'password_templates/:id/form', :to => 'password_templates#form'
