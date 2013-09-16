require File.expand_path('../../spec_helper', __FILE__)

describe PasswordInstance do

  describe "Associations" do
    it { should belong_to(:project) }
    it { should belong_to(:password_template) }
  end

  describe "Validations" do
    # password_template
    it { should validate_presence_of(:password_template) }
    # project
    it { should validate_presence_of(:project) }
    # name
    ['+abcd','Abc', 'abc 1234'].each do |value|
      it { should_not allow_value(value).for(:name) }
    end
    it { should allow_value("hulla_123").for(:name) }
    # data is validity is checked in password_schema
  end

  describe "Encryption" do

    let(:data_plain) do
      '{}'
    end

    let(:pi1) do
      pi1 = PasswordInstance.new()
      pi1.data_plain = data_plain
      pi1
    end


    it "data should be saved encrypted"  do

      pi1.data.should_not == pi1.data_encrypted

    end          #

    it "data should be encryptable"  do

      pi2 = PasswordInstance.new()
      pi2.data_encrypted = pi1.data_encrypted
      pi2.data_encrypted_iv = pi1.data_encrypted_iv
      pi2.data_encrypted_salt = pi1.data_encrypted_salt

      pi1.data.should_not == pi1.data_encrypted


      pi1.data_encrypted.should == pi2.data_encrypted

      pi1.data_plain.should == data_plain
      pi2.data_plain.should == data_plain


      pi1.data.should_not == pi2.data_encrypted

    end

  end




end