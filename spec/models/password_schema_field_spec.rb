require File.expand_path('../../spec_helper', __FILE__)

describe PasswordSchemaField do

  describe "Validations" do
    # type
    it { should validate_presence_of(:type) }
    ['lan','abc1234'].each do |value|
      it { should_not allow_value(value).for(:type) }
    end
    ['text','password'].each do |value|
      it { should allow_value(value).for(:type) }
    end
    # name
    ['+abcd','abc 1234'].each do |value|
      it { should_not allow_value(value).for(:name) }
    end
    it { should allow_value("hulla_123").for(:name) }
    it { should_not allow_value(nil).for(:name) }
  end

  describe "SchemaValidations" do

    it { should_not allow_value("hulla_123").for(:schema) }
    it { should_not allow_value("[]").for(:schema) }
    it { should_not allow_value([]).for(:schema) }

    it { should allow_value("{}").for(:schema) }
    it { should allow_value({}).for(:schema) }

  end


  describe "DataValidations" do

    describe "Required" do

      before(:each) do
        @field = PasswordSchemaField.new({"type"=>"text", "validate" => {"required" => true}})
      end

      it "should validate" do
        @field.value = "im_not_empty"
        @field.valid_data?.should be_true
      end

      it "should not validate" do
        @field.value = ""
        @field.valid_data?.should_not be_true

        @field.value = nil
        @field.valid_data?.should_not be_true
      end
    end

    describe "Emails" do

      before(:each) do
        @field = PasswordSchemaField.new('{"type":"email"}')
      end

      it "should validate" do
        @field.value = "email@provider.de"
        @field.valid_data?.should be_true

        @field.value = "test1234@example.com"
        @field.valid_data?.should be_true
      end

      it "should not validate" do
        @field.value = "no.at.valid-email.de"
        @field.valid_data?.should_not be_true
      end
    end

    describe "URLs" do

      before(:each) do
        @field = PasswordSchemaField.new('{"type":"url"}')
      end

      it "should validate" do
        @field.value = "htTp://www.giigle.de/testme12345.php"
        @field.valid_data?.should be_true

        @field.value = "https://ssl.giigle.de/testme12345.php"
        @field.valid_data?.should be_true
      end

      it "should not validate" do
        @field.value = "htt://asd.simonswine.de"
        @field.valid_data?.should_not be_true
      end

    end



  end

end
