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


end
