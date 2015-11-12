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

  @spec match_count?(String.t, parsed_json, number) :: boolean
  def match_count?(json, path, expected_count) do
    Inspector.traverse path, json, fn(value)->
      do_count(value, expected_count)
    end
  end

  defp do_count(value, _) when not is_list(value), do: {:failure, "#{inspect value} is not an array"}
  defp do_count(value, expected_count), do: Enum.count(value) == expected_count
end
