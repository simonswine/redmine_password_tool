class AddUpdatedCreatedPasswordTool< ActiveRecord::Migration
  def self.up
    add_column :password_instances, :updated_on, :datetime, :null => false
    add_column :password_instances, :created_on, :datetime, :null => false

    add_column :password_templates, :updated_on, :datetime, :null => false
    add_column :password_templates, :created_on, :datetime, :null => false
  end

  def self.down
    remove_column :password_instances, :updated_on
    remove_column :password_instances, :created_on

    remove_column :password_templates, :updated_on
    remove_column :password_templates, :created_on
  end
end