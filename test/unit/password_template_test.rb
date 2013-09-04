require File.expand_path('../../test_helper', __FILE__)

class PasswordTemplateTest < ActiveSupport::TestCase

  #fixtures :password_templates

  # Replace this with your real tests.
  def test_create

    params = {
        :name => "testschema",
        :schema => '[{"name":"username","id":"username","caption":"Username","type":"text","validate":{"required":true}},{"name":"password","caption":"Password","type":"password","validate":{"required":true}}]'
    }

    template = PasswordTemplate.new(params)

    assert template.save
    template.reload

    assert_equal params[:name], template.name
    assert_equal params[:schema], template.schema

  end

end
