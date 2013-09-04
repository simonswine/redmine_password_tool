class CreatePasswordInstances< ActiveRecord::Migration
  def self.up
    create_table :password_instances do |t|
      t.column :name, :string
      t.column :data_encrypted, :binary
      t.column :project_id, :integer
      t.column :password_template_id, :integer
    end
  end

  def self.down
    drop_table :password_instances
  end
end
