# encoding: utf-8
require 'redmine'

Redmine::Plugin.register :redmine_password_tool do
  name 'Redmine Password Tool'
  author 'Christian Simon'
  description 'Integrates password management for Redmine projects'
  version '0.0.1'
  url 'http://www.former03.de'

  settings  :partial => 'redmine_password_tool',
            :default => {

            }

  # Menu entry in project's menu
  menu :project_menu, :password_instances, { :controller => 'password_instances', :action => 'index' }, :after => :wiki, :param => :project_id

  project_module :password_instances do
    permission :pt_read,   :password_instances => [:index, :show, :data_schema]
    permission :pt_modify, :password_instances => [:create, :new, :destroy, :edit, :update]
  end



end

# Include plugins javascript
class PasswordToolJavascriptIncludes < Redmine::Hook::ViewListener
  render_on :view_layouts_base_html_head, :partial => 'password_tool'
end
