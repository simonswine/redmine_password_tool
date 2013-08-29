require 'json'

class PasswordTemplate < ActiveRecord::Base
  unloadable

  has_many :password_instances, :dependent => :destroy



  def get_form
    fields = JSON.parse(schema)
    dform = {
        "action" => "index.html",
        "method" => "get",
        "html" => fields}
    JSON.generate dform
  end

end
