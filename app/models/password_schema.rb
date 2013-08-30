require 'json'

class PasswordSchema

  def initialize(schema)
    if schema.is_a? Array
      @schema = schema
    elsif schema.is_a? String
      @schema = JSON.parse(schema)
    else
      @schema = []
    end
  end

  def schema
    @schema
  end

  def field_names

    names = []
    @schema.each { |field|
      names.push(field['name'])
    }
    names

  end

  def field_by_name(name)
    @schema.each { |field|
      if name == field['name']
        return field
      end
    }
    return nil
  end

  def cdslone
    return PasswordSchema.new(to_json)
  end

  def pre_postfix_names(pre,post)
    @schema.each { |field|
      field['name']="#{pre}#{field['name']}#{post}"
    }
  end

  def export_json
    JSON.generate(@schema)
  end

  def form_json(data=nil)

    temp_schema = PasswordSchema.new(export_json)

    # Use existing data
    if data != nil
      temp_schema.append_data(data)
    end

    # Pre-/Postfix Names
    temp_schema.pre_postfix_names("data[","]")


    dform = {
          "html" => [
              "type" => "div",
              "class" => "ui-dform-div-main",
              "html" => temp_schema.schema,
          ]}
    JSON.generate(dform)

  end

  def append_data(data)
    @schema.each { |field|
      if data.has_key?(field['name'])
        field['value'] = data[field['name']]
      end
    }
  end


end