class PasswordSchema

  attr_reader :errors_data


  # Separate to single fields an initialize them
  def initialize(schema)

    # Convert json string
    if schema.is_a? String
      schema = JSON.parse(schema)
    end

    @fields = {}
    @field_names = []

    # Check if it is a array
    if schema.is_a? Array
      schema.each{ |field|
       field_obj = PasswordSchemaField.new(field)
       if field_obj.valid?
         @field_names.push field_obj.name
         @fields[field_obj.name] = field_obj
       else
         # TODO: Handle wrong schemas
       end
      }
    end
  end

  # Get validated schema
  def schema
    output = []
    @field_names.each { |key|

      field=@fields[key]
      output.push field.to_hash

    }

    output

  end

  def form_json(data=nil)

    my_schema = data_schema(data)

    my_schema.each { |field|
      field['name'] = "data[#{field['name']}]"
    }

    dform = {
    "html" => [
    "type" => "div",
    "class" => "ui-dform-div-main",
    "html" => my_schema,
    ]}
    JSON.generate(dform)

  end

  def data_schema_json(data=nil)

    JSON.generate(data_schema(data))

  end

  def data_schema (data=nil)

    reset_values

    if  data != nil
      params = {
        'data' => data,
        'errors' => {
            '__global' => [],
        },
      }
      data_convert_json(params)

      if params['errors']['__global'].length == 0
        set_values (params['data'])
      end

      output = schema
      reset_values
      output
    else
      schema
    end


  end

  # Validate Input an pass errors and correct data
  def data_validate (data)

    params = {
        'data' => data,
        'errors' => {
            '__global' => [],
        },
    }

    reset_values

    data_convert_json(params)



    # If error happend, pass data to fields
    if params['errors']['__global'].length == 0
      set_values (params['data'])

      data_validate_fields(params['errors'])
    end

    reset_values

    params

  end


  private

  # Reset value per field
  def reset_values
    @field_names.each { |key|
      @fields[key].value = nil
    }
  end

  # Set value per field from hash
  def set_values (data)
    @field_names.each { |key|
      field=@fields[key]
      if data.has_key? key
        field.value = data[key]
      end
    }
  end

  # Convert string to hash and check thats a hash
  def data_convert_json(params)

    # Convert string to hash
    if params['data'].is_a? String
      begin
        params['data']=JSON.parse(params['data'])
      rescue JSON::ParserError
        params['errors']['__global'] << 'validate_json_unparseable'
      end
    end

    # Check if data is a hash
    if  not params['data'].is_a? Hash
      params['errors']['__global'] << 'validate_json_wrong_format'
    end

  end

  # Validate data per field
  def data_validate_fields(errors)

    @field_names.each { |key|
      field=@fields[key]

      if not field.valid_data?
        errors[key] = field.errors_data
      end
    }
  end


end
