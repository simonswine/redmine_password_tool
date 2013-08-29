class CreatePasswordTemplates < ActiveRecord::Migration
  def self.up
    create_table :password_templates do |t|
      t.column :name, :string
      t.column :schema, :text
    end
  end

  def self.down
    drop_table :password_templates
  end
end
