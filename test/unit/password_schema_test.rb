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
    assert_equal JSON.parse(schema_simple).length, schema.schema.length
    schema.schema[0].assert_valid_keys('name', 'caption','type','validate')
  end

  def test_create_json_string
    schema = PasswordSchema.new(schema_simple)
    assert_equal JSON.parse(schema_simple).length, schema.schema.length
    schema.schema[0].assert_valid_keys('name', 'caption','type','validate')
  end

  def test_validate_data_with_optional

    schema = PasswordSchema.new(schema_simple)
    schema_before = schema.schema

    result = schema.data_validate(data_simple)

    # schema not tainted
    assert_equal schema_before, schema.schema

    # check validation
    assert result['errors'].assert_valid_keys('__global')
    assert_equal result['errors']['__global'],[]

    # check data
    assert_equal data_simple, result['data']


  end

  def test_validate_data_without_optional

    schema = PasswordSchema.new(schema_simple)
    schema_before = schema.schema

    data = data_simple.except('option')
    result = schema.data_validate(data)

    # schema not tainted
    assert_equal schema_before, schema.schema

    # check validation
    result['errors'].assert_valid_keys('__global')
    assert_equal result['errors']['__global'],[]

    # check data
    assert_equal data, result['data']


  end

  def test_not_validate_data_without_mandatory

    schema = PasswordSchema.new(schema_simple)
    schema_before = schema.schema

    data = data_simple.except("username")
    result = schema.data_validate(data)

    # schema not tainted
    assert_equal schema_before, schema.schema

    # check validation
    result['errors'].assert_valid_keys('__global',"username")
    assert_equal result['errors']['__global'],[]

    # check data
    assert_equal data, result['data']

  end


  def test_get_form_json

    schema = PasswordSchema.new(schema_simple)

    form_string = schema.form_json
    form_hash = JSON.parse(form_string)

    assert form_string.is_a?(String)
    assert form_hash['html'][0]['html'].is_a?(Array)
    form_hash['html'][0]['html'][0].assert_valid_keys('type','caption','name','validate')

  end



end
