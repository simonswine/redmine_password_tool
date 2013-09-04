require File.expand_path('../../test_helper', __FILE__)

class PasswordSchemaFieldTest < ActiveSupport::TestCase

  #fixtures :password_templates

  @@schema_simple = {"name"=>"test_1234", "type"=>"text", "caption" => "Test 123"}
  @@schema_require = {"name"=>"test_1234", "type"=>"text", "caption" => "Test 123","validate" => {"required" => true}}
  @@schema_not_require = {"name"=>"test_1234", "type"=>"text", "caption" => "Test 123","validate" => {"required" => false}}

  def test_create #_from_json_string

    field = PasswordSchemaField.new(@@schema_simple)

    assert field.valid?
    assert_equal field.to_hash, @@schema_simple
    assert_equal field.name, @@schema_simple["name"]
    assert_equal field.type, @@schema_simple["type"]
    assert_equal field.caption, @@schema_simple["caption"]


  end

  def test_create_from_json_string

    field = PasswordSchemaField.new(JSON.generate(@@schema_simple))

    assert field.valid?
    assert_equal field.to_hash, @@schema_simple
    assert_equal field.name, @@schema_simple["name"]
    assert_equal field.type, @@schema_simple["type"]
    assert_equal field.caption, @@schema_simple["caption"]

  end

  def test_create_required

    field = PasswordSchemaField.new(@@schema_require)

    assert field.valid?
    assert field.validate[:required]
    assert_equal field.name, @@schema_simple["name"]
    assert_equal field.type, @@schema_simple["type"]
    assert_equal field.caption, @@schema_simple["caption"]

  end

  def test_create_not_required

    field = PasswordSchemaField.new(@@schema_not_require)

    assert field.valid?
    assert_equal field.to_hash, @@schema_simple
    assert_equal field.name, @@schema_simple["name"]
    assert_equal field.type, @@schema_simple["type"]
    assert_equal field.caption, @@schema_simple["caption"]

  end

  def test_ignore_non_existing_params

    data = @@schema_simple.clone
    data['not_existing'] = "test123
"
    field = PasswordSchemaField.new(data)

    assert field.valid?
    assert_equal field.to_hash, @@schema_simple
    assert_equal field.name, @@schema_simple["name"]
    assert_equal field.type, @@schema_simple["type"]
    assert_equal field.caption, @@schema_simple["caption"]

  end



  def test_not_valid_missing_name

    field = PasswordSchemaField.new(@@schema_simple.except("name"))

    assert (not field.valid?)

  end

  def test_not_valid_wrong_name

    schema = @@schema_simple.clone
    schema["name"] = "!-adsdasd"

    field = PasswordSchemaField.new(schema)

    assert (not field.valid?)

  end

  def test_not_valid_missing_type

    field = PasswordSchemaField.new(@@schema_simple.except("type"))

    assert (not field.valid?)

  end

  def test_not_valid_wrong_type

    schema = @@schema_simple.clone
    schema["type"] = "i_dont_exist"

    field = PasswordSchemaField.new(schema)

    assert (not field.valid?)

  end

  def test_validate_value_not_required

    schema = @@schema_simple

    field = PasswordSchemaField.new(schema)
    field.value = ""
    assert (field.valid_data?)

    field.value = nil
    assert (field.valid_data?)

  end

  def test_not_validate_value_required

    schema = @@schema_require

    field = PasswordSchemaField.new(schema)
    field.value = ""
    assert (not field.valid_data?)

    field.value = nil
    assert (not field.valid_data?)

  end

  def test_validate_value_email

    schema = @@schema_simple.clone
    schema["type"] = "email"

    field = PasswordSchemaField.new(schema)
    field.value = "simon@swine.de"

    assert (field.valid_data?)

  end

  def test_not_validate_value_email

    schema = @@schema_simple.clone
    schema["type"] = "email"

    field = PasswordSchemaField.new(schema)
    field.value = "simonswine.de"

    assert (not field.valid_data?)

  end

  def test_validate_value_url

    schema = @@schema_simple.clone
    schema["type"] = "url"

    field = PasswordSchemaField.new(schema)
    field.value = "htTp://www.giigle.de/testme12345.php"
    assert (field.valid_data?)

    field.value = "https://ssl.giigle.de/testme12345.php"
    assert (field.valid_data?)

  end

  def test_not_validate_value_url

    schema = @@schema_simple.clone
    schema["type"] = "url"

    field = PasswordSchemaField.new(schema)
    field.value = "htt://asd.simonswine.de"

    assert (not field.valid_data?)

  end


end
