require File.expand_path('../../spec_helper', __FILE__)

describe PasswordSchema do

  let (:schema_simple) do
    '[{"name":"username","caption":"Username","type":"text","validate":{"required":true}},{"name":"password","caption":"Password","type":"password","validate":{"required":true}},{"name":"option","caption":"Option","type":"text"}]'
  end

  describe "SchemaValidations" do

    it "should create from array" do
      schema = PasswordSchema.new(JSON.parse(schema_simple))
      JSON.parse(schema_simple).length.should == schema.schema.length
      schema.schema[0].should have_key('name')
      schema.schema[0].should have_key('caption')
      schema.schema[0].should have_key('type')
      schema.schema[0].should have_key('validate')
    end

    it "should create from json string" do
      schema = PasswordSchema.new(schema_simple)
      JSON.parse(schema_simple).length.should == schema.schema.length
      schema.schema[0].should have_key('name')
      schema.schema[0].should have_key('caption')
      schema.schema[0].should have_key('type')
      schema.schema[0].should have_key('validate')
    end

  end


  describe "DataValidations" do
    let (:data_simple) do
      {"username"=>"test1", "password"=>"test123", "option"=>"no_option"}
    end

    it "should not taint schema"  do
      schema = PasswordSchema.new(schema_simple)
      schema_before = schema.schema

      schema.data_validate(data_simple)

      # schema not tainted
      schema_before.should == schema.schema
    end

    it "should validate data with optional"  do
      schema = PasswordSchema.new(schema_simple)
      schema = PasswordSchema.new(schema_simple)

      result = schema.data_validate(data_simple)


      # check validation
      {'__global' => []}.should include(result['errors'])

      # check data
      data_simple.should == result['data']
    end

    it "should validate data without optional"  do
      schema = PasswordSchema.new(schema_simple)
      schema = PasswordSchema.new(schema_simple)

      data = data_simple.except('option')
      result = schema.data_validate(data)


      # check validation
      {'__global' => []}.should include(result['errors'])

      # check data
      data.should == result['data']
    end

    it "should not validate data without required"  do
      schema = PasswordSchema.new(schema_simple)
      schema = PasswordSchema.new(schema_simple)

      data = data_simple.except('username')
      result = schema.data_validate(data)


      # check validation
      {'__global' => [],'username'=> ["validate_required_missing"]}.should include(result['errors'])

      # check data
      data.should == result['data']
    end

  end

  describe "HTMLForm" do

    it "should output right format" do
      schema = PasswordSchema.new(schema_simple)

      form_string = schema.form_json
      form_hash = JSON.parse(form_string)

      form_string.is_a?(String)
      form_hash['html'][0]['html'].is_a?(Array).should eq(true)
      form_hash['html'][0]['html'][0].should include('type','caption','name','validate')
    end
  end

end
