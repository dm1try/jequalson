defmodule JequalSON.Inspector do
  alias JequalSON, as: J

  @spec traverse(String.t, J.parsed_json_object, fun) :: boolean
  def traverse(path, json, callback) do
    locations = build_locations(path)
    traverse_locations(locations, json, callback)
  end

  defp traverse_locations([{ location, :all = index } | []], json, callback) do
    collection_result(index, json[location], fn(item)->
      callback.(item)
    end)
  end

  defp traverse_locations([{ location, :all = index } | remaining], json, callback) do
    collection_result(index, json[location], fn(item) ->
      traverse_locations(remaining, item, callback)
    end)
  end

  defp traverse_locations([{ location, :any = index} | []], json, callback) do
    collection_result(index, json[location], fn(item) ->
      callback.(item)
    end)
  end

  defp traverse_locations([{ location, :any = index} | remaining], json, callback) do
    collection_result(index, json[location], fn(item) ->
      traverse_locations(remaining, item, callback)
    end)
  end

  defp traverse_locations([{ location, index } | []], json, callback)
    when is_integer(index)
  do
    collection_result(index, json[location], fn(value)->
      callback.(value)
    end)
  end

  defp traverse_locations([{ location, index } | remaining], json, callback)
    when is_integer(index)
  do
    collection_result(index, json[location], fn(value)->
      traverse_locations(remaining, value, callback)
    end)
  end

  defp traverse_locations(locations, json, callback) do
    member_result(get_in(json, locations), callback)
  end

  defp collection_result(_, nil, _) do
    {:error, :path_not_found}
  end

  defp collection_result(:all, value, _)
    when not is_list(value)
  do
    {:error, {:not_an_array, value}}
  end

  defp collection_result(:all, array, result_callback) do
    Enumerable.reduce(array, {:cont, true}, fn(item, _) ->
      case result_callback.(item) do
        true -> {:cont, true}
        failure -> {:halt, failure}
      end
    end) |> elem(1)
  end

  defp collection_result(:any, array, result_callback) do
    Enumerable.reduce(array, {:cont, {:failure, "no any success"}}, fn(item, _) ->
      case result_callback.(item) do
        true -> {:halt, true}
        failure-> {:cont, failure}
      end
    end) |> elem(1)
  end

  defp collection_result(index, array, result_callback)
    when is_integer(index)
  do
    Enum.fetch(array, index)
      |> collection_member_result(result_callback)
  end

  defp collection_member_result({:ok, value}, result_callback) do
    result_callback.(value)
  end

  defp collection_member_result(:error, _) do
    {:error, :out_of_bound}
  end

  defp member_result(nil, _) do
    {:error, :path_not_found}
  end

  defp member_result(value, callback) do
    callback.(value)
  end

  defp build_locations(path) do
    path
     |> String.split(".")
     |> Enum.map(fn(location) ->
         captures = Regex.named_captures(~r/\[(?<index>.*)\]$/, location)
         if captures, do: build_array_location(location, captures["index"]), else: location
        end)
  end

  defp build_array_location(location, captured_index) do
    compiled_index = case captured_index do
      "*" -> :all
      "?" -> :any
       x  -> String.to_integer(x)
    end

    { String.replace(location, "[#{captured_index}]", ""), compiled_index }
  end
end
