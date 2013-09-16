require 'uri'

class PasswordSchemaField

  include ActiveModel::Validations

  attr_accessor :type, :name, :validate, :caption, :value

  attr_reader :errors_data

  @@allowed_types = ['text','password','url','email','number']
  @@hash_fields = ['type','name','validate','caption','value']


  validates :name, :type, presence: true
  validates_format_of :name, :with => /\A[a-z0-9_]+\Z/, :message => "l(:validate_only_small_alphanumeric_underscore)"
  validates :type, inclusion: { in: ['text','password','url','email','number'] }
  validate :valid_schema


  def initialize(params={})

    self.schema=params

  end

  def schema
    @schema
  end

  def schema=(params)

    @schema = params

    if params.is_a? String
      begin
        params =  JSON.parse(params)
      rescue JSON::ParserError
        return
      end
    end

    if params.is_a? Hash
      # Set instance vars
      begin
        params.each { |key, value| send "#{key}=", value }
      rescue NoMethodError

      end
    end


  end

  def valid_schema

    my_schema = @schema

    if my_schema.nil?
      return
    end

    if my_schema.is_a? String
      begin
        my_schema =  JSON.parse(my_schema)
      rescue JSON::ParserError
        errors.add(:schema, 'json_unparseable')
        return
      end
    end

    if not my_schema.is_a? Hash
      errors.add(:schema, 'schema_no_hash')
    end

  end

  def name=(val)
    if val.nil?
      @name = nil
    else
      @name = val.downcase
    end
  end

  def type=(val)
    if val.nil?
      @type = nil
    else
      @type = val.downcase
    end
  end

  def caption
    @caption || @name
  end

  def validate=(val)
    if val.is_a? Hash
      if val.has_key? "required" and val["required"].is_a?(TrueClass)
        @validate = {required: true}
      end
    end
  end

  def to_hash
    hash = {}
    @@hash_fields.each {|key|
      value = send key

    if value != nil
        hash[key] = value
      end
    }
    hash

  end

  # Validate value
  def valid_data?
    @errors_data = []

    empty = value_empty?

    if validate != nil and validate[:required] and empty
      @errors_data << 'validate_required_missing'
    end

    # Check validity
    begin
      send "value_#{type}_valid?"
    rescue NoMethodError
      value_valid?
    end

    if @errors_data.length == 0
      return true
    else
      return false
    end



  end


  # Default validator for text, checks if not empty string
  def value_valid?
     return true
  end

  # Default empty_tester for text, checks if not empty string
  def value_empty?
    if value === nil or value === ""
      return true
    end
    return false
  end

  # Special validator for emails addresses
  def value_email_valid?
    if value.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i)
      return true
    end
    @errors_data << 'validate_invalid_email'
    return false
  end

  # Special validator for urls addresses
  def value_url_valid?
    begin
      uri = URI.parse(value)
      uri = URI.parse("http://#{url}") if uri.scheme.nil?
      if uri.scheme.downcase != 'http' and uri.scheme.downcase != 'https'
        @errors_data << 'validate_no_http_s_url'
        return false
      end
      value = uri.to_s
      return true
    rescue
      @errors_data << 'validate_invalid_url'
      return false
    end
  end



end