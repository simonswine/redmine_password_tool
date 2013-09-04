
class PasswordSchemaField

  include ActiveModel::Validations

  attr_accessor :type, :name, :validate, :caption, :value

  validates :name, :type, presence: true
  validates_format_of :name, :with => /\A[a-z0-9_]+\Z/, :message => "l(:validate_only_small_alphanumeric_underscore)"
  validates :type, inclusion: { in: ['text','password','url','email','number'] }

  def initialize(params={})
    
    if params.is_a? String
      params =  JSON.parse(params)
    end

    if params.is_a? Hash
      # Set instance vars
      params.each { |key, value| send "#{key}=", value }
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

end