class PasswordInstance < ActiveRecord::Base
  unloadable

  belongs_to :password_template
  belongs_to :project

  # TODO: Load key from file
  attr_encrypted :data_plain, :key => :get_secret, :attribute => 'data_encrypted'

  # Unique names on project scope
  validates :name, :uniqueness => {:scope => :project_id}
  validates_length_of :name, :minimum => 3
  # Only allow a-z0-9_
  validates_format_of :name, :with => /\A[a-z0-9\-_]+\Z/, :message => l(:validate_only_small_alphanumeric_underscore)

  # Needs project_id
  validates :project, :presence => true
  validates :password_template, :presence => true

  # data validation
  validate :validate_data

  # Nested set of instances order by name
  acts_as_nested_set :order => :name, :dependent => :destroy


  # Path to secrets file
  @@secrets_file = File.expand_path(File.dirname(__FILE__) + "../../../config/password_tool_secret.yml")

  # Get classes for the password_instance tree
  def css_classes
    s = 'project'
    s << ' root' if root?
    s << ' child' if child?
    s << (leaf? ? ' leaf' : ' parent')
    s
  end

  def get_secret
    PasswordInstance.get_secret
  end

  # Get hash of data
  def data
    JSON.parse(data_plain)
  end

  def data=(val)
    data_plain=JSON.generate(val)
  end

  def validate_data
    if not password_template.nil?
      result = password_template.data_validate(data_plain)
      if not (result['errors'].length == 1 and result['errors']['__global'].length == 0)
        errors.add(:data_plain, result['errors'])
      end
    end
  end

  # Get json tree of data and schema
  def data_schema_json
    JSON.generate(data_schema)
  end

  # Get tree of data and schema
  def data_schema
    password_template.schema_obj.data_schema(data_plain)
  end

  # Recalculates all lft and rgt values based on password instances name
  def self.rebuild_tree!
    transaction do
      update_all "lft = NULL, rgt = NULL"
      rebuild!(false)
    end
  end

  # Yields the given block for each password_instance with its level in the tree
  def self.password_instance_tree(password_instances, &block)
    ancestors = []
    password_instances.sort_by(&:lft).each do |password_instance|
      while (ancestors.any? && !password_instance.is_descendant_of?(ancestors.last))
        ancestors.pop
      end
      yield password_instance, ancestors.size
      ancestors << password_instance
    end
  end

  def validate_data_plain_json_parseable
    if data_plain.present?
      begin
        JSON.parser(data_plain)
      rescue JSON::ParserError
        errors.add(:data, "json_unparseable")
      end
    end
  end


  def self.get_secret
    YAML.load(File.open(@@secrets_file))['secret']
  end


  def self.create_secret

    # Check that no secrets exists
    begin
      secret = get_secret
    rescue Exception => e
      secret = nil
    end

    if secret.nil?

      if PasswordInstance.count > 0
        # Already existing PasswordInstances

        raise "Can't create secret, because there is at least a existing password entry"

      else
        # No instance exists
        puts "Generate a secret key"

        secret={
            'secret' => SecureRandom.base64(128)
        }

        # Write file
        File.write(@@secrets_file, secret.to_yaml)

        # Only owner rights
        File.chmod(0600, @@secrets_file)

      end


    else
      raise "Secret already existing"
    end

  end

end