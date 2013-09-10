require File.expand_path('../../test_helper', __FILE__)

class PasswordInstancesControllerTest < ActiveSupport::TestCase

  fixtures :projects, :users, :roles, :members, :member_roles, :enabled_modules

  ActiveRecord::Fixtures.create_fixtures(File.expand_path('../../fixtures', __FILE__), [:password_templates,:password_instances])

  def setup
    User.current = nil
  end

  def test_index

    get :index, :project_id => 'ecookbook'
    assert_response :success
    assert_template 'index'

  end

end
