require 'json'

class PasswordTemplate < ActiveRecord::Base
  unloadable

  has_many :password_instances, :dependent => :destroy

  def schema_obj
    PasswordSchema.new(schema)
  end

  def data_validate(data)
    schema_obj.data_validate(data)
  end



  # Changes name key of schema adds prefix,suffix to name
  def self.change_name_keys(obj, prefix, suffix)

    # Handle array -> recursion
    if obj.class == Array
      obj.each { |item|
        item = self.change_name_keys(item, prefix, suffix)
      }

      # Handle hash
    elsif obj.class == Hash
      obj.each { |key, value|

        # Recursion
        if value.class == Hash or value.class == Array
          obj[key] = self.change_name_keys(value, prefix, suffix)
          # Actual work
        else
          if key == 'name'
            obj[key] = "#{prefix}#{value}#{suffix}"
          end
        end
      }
    end

    obj

  end

  # Build options for form selects
  def self.template_options_for_form
    templates = [["<#{l(:label_pt_select)}>",0]]
    PasswordTemplate.order("name").all.each { |template|
      templates.push([template.name,template.id])
    }
    templates
  end


end
