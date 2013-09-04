require 'uri'

class PasswordSchemaField

  include ActiveModel::Validations

  attr_accessor :type, :name, :validate, :caption, :value

  attr_reader :errors_data

  @@allowed_types = ['text','password','url','email','number']

  validates :name, :type, presence: true
  validates_format_of :name, :with => /\A[a-z0-9_]+\Z/, :message => "l(:validate_only_small_alphanumeric_underscore)"
  validates :type, inclusion: { in: ['text','password','url','email','number'] }



  def initialize(params={})
    
    if params.is_a? String
      params =  JSON.parse(params)
    end

    if params.is_a? Hash
      # Set instance vars
      begin
        params.each { |key, value| send "#{key}=", value }
      rescue NoMethodError

      end
    end
  end

  def name=(val)
    @name = val.downcase
  end

  def type=(val)
    @type = val.downcase
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
    instance_variables.each {|var|
      key=var.to_s
      key[0] = ''
      if not ["errors","validation_context"].include?(key)
        hash[key] = instance_variable_get(var)
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