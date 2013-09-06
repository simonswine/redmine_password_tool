class CreateTablesPasswordTool < ActiveRecord::Migration
  def self.up
    create_table :password_templates do |t|
      t.column :name, :string
      t.column :schema, :text
      t.column :updated_on, :datetime, :null => false
      t.column :created_on, :datetime, :null => false
    end

    create_table :password_instances do |t|
      t.column :name, :string
      t.column :data_encrypted, :text
      t.column :data_encrypted_salt, :string
      t.column :data_encrypted_iv, :string
      t.column :project_id, :integer
      t.column :password_template_id, :integer
      t.column :parent_id, :integer, :default => nil
      t.column :root_id, :integer, :default => nil
      t.column :lft, :integer, :default => nil
      t.column :rgt, :integer, :default => nil
      t.column :updated_on, :datetime, :null => false
      t.column :created_on, :datetime, :null => false
    end

    add_index :password_instances, [:root_id, :lft, :rgt]
  end

  def self.down
    drop_table :password_templates
    drop_table :password_instances
  end
end