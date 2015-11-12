defmodule JequalSON.InspectorSpec do
  use ESpec
  alias JequalSON.Inspector

  describe ".traverse" do
    let :parsed_json do
       %{ "test" => "value",
          "child" => %{ "id" => 1},
          "array" => [1,2,3],
          "array_of_objects" => [%{ "name" => "object1" },
                                 %{ "name" => "object2" }]
        }
    end
    before do
      {:ok, agent} = Agent.start_link(fn-> [] end)
      {:shared, traversed_values: agent}
    end
    let :traversed_values do
      Agent.get(shared.traversed_values, fn(list)->
        list
      end)
    end
    let :callback, do: fn(value) ->
      Agent.update(shared.traversed_values, fn(list)->
        list ++ [value]
      end)
    end

    context "simple path" do
      let :path, do: "test"

      it "traverses a value using provided calback if the path is valid" do
        Inspector.traverse(path, parsed_json, callback)
        expect(traversed_values).to eq ["value"]
      end

      it "returns an error response if path is invalid" do
        result = Inspector.traverse("unknown_path", parsed_json, callback)

        expect(result).to eq {:error, :path_not_found}
        expect(traversed_values).to eq []
      end
    end

    context "nested path" do
      let :path, do: "child.id"

      it "traverses a value using provided calback if the path is valid" do
        Inspector.traverse(path, parsed_json, callback)
        expect(traversed_values).to eq [1]
      end

      it "returns an error response if path is invalid" do
        expect(
          Inspector.traverse("child.unknown", parsed_json, callback)
        ).to eq {:error, :path_not_found}
      end
    end

    context "collections" do
      context "[*] index - ALL" do
        it "returns an error response if path is invalid" do
           expect(
            Inspector.traverse("array_unknown[*]", parsed_json, callback)
          ).to eq {:error, :path_not_found}

          expect(
            Inspector.traverse("array_unknown[*].with_nested_path", parsed_json, callback)
          ).to eq {:error, :path_not_found}
        end

        context "the path is valid" do
          let :path, do: "array[*]"

          context "the callback returns true" do
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              true
            end

            it "traverses whole collection and returns true" do
              result = Inspector.traverse(path, parsed_json, callback)

              expect(traversed_values).to eq [1,2,3]
              expect(result).to be_truthy
            end
          end

          context "the callback returns 'false'" do
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              false
            end

            it "breaks the traversing next values and returns false" do
              result = Inspector.traverse(path, parsed_json, callback)

              expect(traversed_values).to eq [1]
              expect(result).to be_falsy
            end
          end

          context "collection with nested objests" do
            let :path, do: "array_of_objects[*].name"
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              String.match?(value, ~r/object/)
            end

            it do
              expect(
                Inspector.traverse(path, parsed_json, callback)
              ).to be_truthy

              expect(traversed_values).to eq ["object1", "object2"]
            end
          end
        end
      end

      context "[?] index - ANY" do
        it "returns an error response if path is invalid" do
           expect(
            Inspector.traverse("array_unknown[?]", parsed_json, callback)
          ).to eq {:error, :path_not_found}

          expect(
            Inspector.traverse("array_unknown[?].with_nested_path", parsed_json, callback)
          ).to eq {:error, :path_not_found}
        end

        context "the path is valid" do
          let :path, do: "array[?]"

          context "the callback returns true" do
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              true
            end

            it "traverses first value and returns true" do
              result = Inspector.traverse(path, parsed_json, callback)

              expect(traversed_values).to eq [1]
              expect(result).to be_truthy
            end
          end

          context "the callback returns false" do
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              false
            end

            it "traverses all values and returns false" do
              result = Inspector.traverse(path, parsed_json, callback)

              expect(traversed_values).to eq [1,2,3]
              expect(result).to be_falsy
            end
          end

          context "collection with nested objests" do
            let :path, do: "array_of_objects[?].name"
            let :callback, do: fn(value) ->
              Agent.update(shared.traversed_values, fn(list)->
                list ++ [value]
              end)

              String.match?(value, ~r/object/)
            end

            it do
              expect(
                Inspector.traverse(path, parsed_json, callback)
              ).to be_truthy

              expect(traversed_values).to eq ["object1"]
            end
          end
        end
      end

      context "[n] index" do
        context "the member is exists" do
          context "the path ends with [..]" do
            let :path, do: "array_of_objects[1]"

            it "traverses value of member" do
              Inspector.traverse(path, parsed_json, callback)
              expect(traversed_values).to eq([%{"name"=> "object2"}])
            end
          end

          context "getting member field value" do
            let :path, do: "array_of_objects[1].name"

            it "traverses value of member" do
              Inspector.traverse(path, parsed_json, callback)
              expect(traversed_values).to eq(["object2"])
            end

            context "the value does not exists" do
              let :path, do: "array_of_objects[1].name2"

              it "returns an error" do
                result = Inspector.traverse(path, parsed_json, callback)

                expect(result).to eq {:error, :path_not_found}
                expect(traversed_values).to eq([])
              end
            end
          end
        end

        context "the member does not exist" do
          let :path, do: "array_of_objects[9999999999]"

          it "returns 'out_of_bound' error" do
            result = Inspector.traverse(path, parsed_json, callback)

            expect(result).to eq {:error, :out_of_bound}
            expect(traversed_values).to eq []
          end
        end

        context "the provided path is not an array" do
          let :path, do: "test[*]"

          it "returns 'not_an_array' error" do
            result = Inspector.traverse(path, parsed_json, callback)

            expect(result).to eq {:error, {:not_an_array, "value"}}
            expect(traversed_values).to eq []
          end
        end
      end
    end
  end
end
