defmodule JequalSON.Comporator do
  alias JequalSON, as: J

  @spec compare(J.parsed_json_object, J.json_schema) :: boolean
  def compare(_, schema)
    when not is_map(schema) and not is_list(schema)
  do
    {:error, "invalid schema" }
  end

  def compare(json, _)
    when not is_map(json) and not is_list(json)
  do
    {:error, "invalid json" }
  end

  def compare(json, schema)
    when is_map(schema) and not is_map(json)
  do
    {:error, "expected #{inspect json} to be an JSON object, but is not" }
  end

  def compare(json, schema)
    when is_list(schema) and not is_list(json)
  do
    {:error, "expected #{inspect json} to be an JSON array, but is not" }
  end

  def compare(json, schema) do
    compare_value(json, schema)
  end

  def compare_value(json, schema) when is_map(json) and is_map(schema) do
    schema = normalized_schema(schema)
    schema_keys = keys_set(schema)
    not_found_keys = Set.difference(schema_keys, keys_set(json))

    if Enum.empty?(not_found_keys) do
      failures = Enum.reduce(schema_keys, [], fn(key, failures)->
        case compare_value(json[key], schema[key]) do
          true -> failures
          {:failure, message} ->  failures ++ [message]
        end
      end)

      Enum.empty?(failures)
       or {:failure, "#{Enum.join(failures, "\n")}"}
    else
      {:failure, "keys #{inspect Set.to_list(not_found_keys)} are not found"}
    end
  end

  def compare_value([], []), do: true

  def compare_value(json, schema) when is_list(json) and is_list(schema) do
    compare_value(List.first(json), List.first(schema))
  end

  # TODO: a macro for those stuff :)
  def compare_value(value, expectation) when is_binary(expectation) do
    value == expectation
      or {:failure, "expected #{value} to be #{expectation}"}
  end

  def compare_value(value, :string) do
    is_bitstring(value)
      or {:failure, "expected #{inspect value} to be a 'String' type"}
  end

  def compare_value(value, :integer) do
    is_integer(value)
      or {:failure, "expected #{inspect value} to be a 'Integer' type"}
  end

  def compare_value(value, :boolean) do
    is_boolean(value)
      or {:failure, "expected #{inspect value} to be a 'Boolean' type"}
  end

  def compare_value(value, :object) do
    is_map(value)
      or {:failure, "expected #{inspect value} to be a 'Object' type"}
  end

  def compare_value(value, :array) do
    is_list(value)
      or {:failure, "expected #{inspect value} to be a 'Array' type"}
  end

  def compare_value(value, :nil) do
    is_nil(value)
      or {:failure, "expected #{inspect value} to be nil"}
  end

  def compare_value(_, expectation)
    when is_atom(expectation) and not is_boolean(expectation)
  do
    {:failure, "unknown type #{inspect expectation}"}
  end

  def compare_value(value, expectation) when is_function(expectation) do
    expectation.(value)
      or {:failure, "expected #{inspect value} to be truthy for #{inspect expectation}"}
  end

  def compare_value(value, expectation) do
    value === expectation ||
      {:failure, "expected #{inspect value} to eq #{inspect expectation}"}
  end

  defp normalized_schema(schema) do
    schema
      |> Enum.map(fn({k,v})-> { to_string(k), v } end)
      |> Enum.into(%{})
  end

  defp keys_set(map) do
    map
     |> Map.keys
     |> Enum.into(HashSet.new)
  end
end
