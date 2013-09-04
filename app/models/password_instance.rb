class PasswordInstance < ActiveRecord::Base
  unloadable

  belongs_to :password_template
  belongs_to :project

  attr_encrypted :data_plain, :key => "test123", :attribute => 'data'

  # Unique names on project scope
  validates :name, :uniqueness => {:scope => :project_id}
  validates_length_of :name, :minimum => 3
  # Only allow a-z0-9_
  validates_format_of :name, :with => /\A[a-z0-9\-_]+\Z/, :message => l(:validate_only_small_alphanumeric_underscore)



  # Nested set of instances order by name
  acts_as_nested_set :order => :name, :dependent => :destroy

  # Get classes for the password_instance tree
  def css_classes
    s = 'project'
    s << ' root' if root?
    s << ' child' if child?
    s << (leaf? ? ' leaf' : ' parent')
    s
  end

  # Get json tree of data
  def data_json
    my_data = JSON.parse(data_plain)
    JSON.pretty_generate(my_data)
  end

  # Get json tree of data and schema
  def data_schema_json
    password_template.schema_obj.data_schema_json(JSON.parse(data_plain))
  end



  # Recalculates all lft and rgt values based on password instances name
  def self.rebuild_tree!
    transaction do
      update_all "lft = NULL, rgt = NULL"
      rebuild!(false)
    end
  end

  # Yields the given block for each password_instance with its level in the tree
  def self.password_instance_tree(password_instances,&block)
    ancestors = []
    password_instances.sort_by(&:lft).each do |password_instance|
      while (ancestors.any? && !password_instance.is_descendant_of?(ancestors.last))
        ancestors.pop
      end
      yield password_instance, ancestors.size
      ancestors << password_instance
    end
  end



end