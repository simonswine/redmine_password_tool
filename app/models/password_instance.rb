class PasswordInstance < ActiveRecord::Base
  unloadable

  belongs_to :password_template
  belongs_to :project

end


def get_secret
  Setting.plugin_password_tool['pt_secret']
end