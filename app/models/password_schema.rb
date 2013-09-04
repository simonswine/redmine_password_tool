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

  def clone
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

  def data_schema(data=nil)

    temp_schema = PasswordSchema.new(export_json)

    # Use existing data
    if data != nil
      temp_schema.append_data(data)
    end

    # Pre-/Postfix Names
    temp_schema.pre_postfix_names("data[","]")

    #
    temp_schema.schema
  end

  def data_schema_json(data=nil)
    JSON.generate(data_schema(data))
  end

  def form_json(data=nil)
    dform = {
          "html" => [
              "type" => "div",
              "class" => "ui-dform-div-main",
              "html" => data_schema(data),
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

  def validate_data(data)

    my_output = {}
    my_data = data
    my_errors = []

    if data.is_a? String
      my_data=JSON.parse(data)
    end

    if not my_data.is_a? Hash
      raise "Expected a hash"
    end

    @schema.each { |field|
      if my_data.has_key?(field['name'])
        # Exists




        my_output[field['name']] = my_data[field['name']]
      else
        # Not exits

        if field['validate']['required'] === true
          my_errors.push("feld #{field['caption']} nicht vorhanden")
        end


      end
    }


    my_output

  end


end