class AddNestedSetPasswordInstances< ActiveRecord::Migration
  def self.up
    add_column :password_instances, :parent_id, :integer, :default => nil
    add_column :password_instances, :root_id, :integer, :default => nil
    add_column :password_instances, :lft, :integer, :default => nil
    add_column :password_instances, :rgt, :integer, :default => nil

    add_index :password_instances, [:root_id, :lft, :rgt]

    PasswordInstance.update_all("parent_id = NULL, root_id = id, lft = 1, rgt = 2")
  end

  def self.down
    remove_index :password_instances, [:root_id, :lft, :rgt]

    remove_column :password_instances, :parent_id
    remove_column :password_instances, :root_id
    remove_column :password_instances, :lft
    remove_column :password_instances, :rgt


  end
end