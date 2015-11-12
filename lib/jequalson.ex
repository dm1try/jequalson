defmodule JequalSON do
  @type parsed_json_array :: list
  @type parsed_json_object :: map
  @type parsed_json :: parsed_json_object | parsed_json_array

  @type json_schema :: map | list

  alias JequalSON.Inspector
  alias JequalSON.Comporator

  @spec match?(parsed_json, json_schema) :: boolean
  def match?(json, schema) do
    Comporator.compare(json, schema)
  end

  @spec match?(String.t, parsed_json, map) :: boolean
  def match?(json, path, schema) do
    Inspector.traverse path, json, fn(value)->
      Comporator.compare(value, schema)
    end
  end
end
