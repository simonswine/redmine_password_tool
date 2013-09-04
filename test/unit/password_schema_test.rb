require File.expand_path('../../test_helper', __FILE__)

class PasswordSchemaTest < ActiveSupport::TestCase

  def schema_simple
    '[{"name":"username","caption":"Username","type":"text","validate":{"required":true}},{"name":"password","caption":"Password","type":"password","validate":{"required":true}},{"name":"option","caption":"Option","type":"text"}]'
  end
  def data_simple
    {"username"=>"test1", "password"=>"test123", "option"=>"noption"}
  end

  def test_create
    schema = PasswordSchema.new(JSON.parse(schema_simple))
    assert_equal schema_simple, JSON.generate(schema.schema)
  end

  def test_create_json_string
    schema = PasswordSchema.new(schema_simple)
    assert_equal schema_simple, JSON.generate(schema.schema)
  end

  def test_validate_data_with_optional

    schema = PasswordSchema.new(schema_simple)
    schema.data = data_simple
    assert schema.valid_data?
    assert_equal data_simple, schema.data

  end

  def test_validate_data_without_optional

    schema = PasswordSchema.new(schema_simple)
    data = data_simple.clone.except('option')
    schema.data = data
    assert schema.valid_data?
    assert_equal data, schema.data

  end

  def test_not_validate_data_without_mandatory

    schema = PasswordSchema.new(schema_simple)
    data = data_simple.clone.except('username')
    schema.data = data
    assert (not schema.valid_data? )
  end



end
