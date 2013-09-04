require File.expand_path('../../test_helper', __FILE__)

class PasswordInstanceTest < ActiveSupport::TestCase

  fixtures :projects
  ActiveRecord::Fixtures.create_fixtures(File.expand_path('../../fixtures', __FILE__), [:password_templates])

  def default_params
    {
      :name => "test_instance",
      :password_template_id => 1,
      :data_plain => '{"username":"username1","password":"password1"}',
      :project_id => 1,
    }.clone
  end

  # Test creation of .
  def test_create

    params = default_params

    pi = PasswordInstance.new(params)

    assert pi.save
    pi.reload

    template = PasswordTemplate.find(1)

    assert_equal params[:name], pi.name
    assert_equal params[:data_plain], pi.data_plain
    assert_equal template.name, pi.password_template.name

  end

  def test_not_create_wrong_name

    params = default_params
    params[:name] = "wrong_NAME"

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

  def test_not_create_empty_name

    params = default_params.except(:name)

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

  def test_not_create_unparseable_json_data

    params = default_params
    params[:data_plain] = '{"no":"json",}'

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

  def test_not_create_invalid_json_data

    params = default_params
    params[:data_json] = '["not","wanted"]'

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

  def test_not_create_missing_project_id
    params = default_params.except(:project_id)

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

  def test_not_create_wrong_project_id
    params = default_params
    params[:project_id] = 666

    pi = PasswordInstance.new(params)

    assert ! pi.save

  end

end
