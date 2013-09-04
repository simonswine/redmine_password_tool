require File.expand_path('../../test_helper', __FILE__)

class PasswordSchemaTest < ActiveSupport::TestCase

  #fixtures :password_templates

  def schema_simple
    '[{"name":"username","id":"username","caption":"Username","type":"text","validate":{"required":true}},{"name":"password","caption":"Password","type":"password","validate":{"required":true}},{"name":"option","caption":"Option","type":"text"}]'
  end
  def data_simple
    {"username"=>"test1", "password"=>"test123", "option"=>"noption"}
  end

  def test_create

    schema = PasswordSchema.new(schema_simple)

    assert_equal JSON.parse(schema_simple), schema.schema

  end

  def test_validate_data_with_optional

    schema = PasswordSchema.new(schema_simple)
    data_result = schema.validate_data(data_simple)
    assert_equal data_simple, data_result

  end

  def test_validate_data_without_optional

    schema = PasswordSchema.new(schema_simple)
    data = data_simple.clone.except("option")
    data_result = schema.validate_data(data)
    assert_equal data, data_result

  end

  def test_not_validate_data_without_mandatory

    schema = PasswordSchema.new(schema_simple)
    data = data_simple.clone.except("username")
    data_result = schema.validate_data(data)

    assert_not_equal data, data_result
  end



end
