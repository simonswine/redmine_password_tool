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

  def valid_data?       #

    reset_values
    result=true


    val = @data_string

    # Convert string to hash
    if val.is_a? String
      begin
        val=JSON.parse(val)
      rescue JSON::ParserError
        @errors_data['__global'] << 'validate_json_unparseable'
      end
    end

    # Check if hash
    if val.is_a? Hash
      @field_names.each { |key|
        field=@fields[key]
        if val.has_key? key
          field.value = val[key]
        end
      }
    else
      @errors_data['__global'] << 'validate_json_wrong_format'
    end

    # If error happend, pass data to fields
    if @errors_data['__global'].length == 0
      @field_names.each { |key|
        field=@fields[key]

        if not field.valid_data?
          @errors_data[key] = field.errors_data
          result = false
        end
      }
    else
      result=false
    end

    result
  end

  def data=(val)

    @data_string = val

  end

  def data
    output = {}
    @field_names.each { |key|
      field=@fields[key]
      if field.valid_data? and field.value != nil
        output[key] = field.value
      end
    }
    output
  end

  def reset_values

    @errors_data = {}
    @errors_data['__global'] = []

    @field_names.each { |key|
      @fields[key].value = nil
    }
  end

end