require File.expand_path('../../spec_helper', __FILE__)

describe PasswordTemplate do

  describe "Associations" do
    it { should have_many(:password_instances) }
  end

  describe "Validations" do
    # name
    ['+abcd','Abc', 'abc 1234'].each do |value|
      it { should_not allow_value(value).for(:name) }
    end
    it { should allow_value("hulla_123").for(:name) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe "Creation" do

    let (:params) do
      {
          :name => "testschema",
          :schema => '[{"name":"username","id":"username","caption":"Username","type":"text","validate":{"required":true}},{"name":"password","caption":"Password","type":"password","validate":{"required":true}}]'
      }
    end


    it "should create a template" do
      template = PasswordTemplate.new(params)
      template.save.should be_true
      template.reload

      params[:name].should == template.name
      params[:schema].should == template.schema
    end
  end


end