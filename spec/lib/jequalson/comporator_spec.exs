defmodule JequalSON.ComporatorSpec do
  use ESpec

  alias JequalSON.Comporator

  describe ".compare" do
    context "bad schema" do
      let :json, do: %{}
      let :schema, do: "not a list"

      it "returns an error" do
        {status, message} = Comporator.compare(json, schema)
        expect(status).to eq :error
        expect(message).to eq "invalid schema"
      end
    end

    context "bad json" do
      let :json, do: "not a json"
      let :schema, do: %{}

      it "returns an error" do
        {status, message} = Comporator.compare(json, schema)
        expect(status).to eq :error
        expect(message).to eq "invalid json"
      end
    end

    context "uncomparable json and schema" do
      context "json - array, schema - object" do
        let :json, do: [1,2,3]
        let :schema, do: %{}

        it "returns an error" do
          {status, message} = Comporator.compare(json, schema)
          expect(status).to eq :error
          expect(message).to eq "expected [1, 2, 3] to be an JSON object, but is not"
        end

        context "json - object, schema - array" do
          let :json, do: %{ "test" => "object" }
          let :schema, do: []

          it "returns an error" do
            {status, message} = Comporator.compare(json, schema)

            expect(status).to eq :error
            expect(message).to eq ~s(expected %{"test" => "object"} to be an JSON array, but is not)
          end
        end
      end

      context "simple match comparison" do
        let :json, do: %{"name" => "Jonh", "surname" => "Doe" }

        context "successful schema" do
          let :schema, do: %{ "name" => "Jonh" }

          it "return succesful result" do
            status = Comporator.compare(json, schema)
            expect(status).to be_true
          end
        end

        context "unsuccessful schema, a bad key" do
          let :schema, do: %{ "name22" => "Jonh"}

          it "return failure result" do
            {status, message} = Comporator.compare(json, schema)

            expect(status).to be :failure
            expect(message).to eq ~s(keys ["name22"] are not found)
          end
        end

        context "unsuccessful schema, a bad value" do
          let :schema, do: %{ "name" => "Jonh2"}

          it "return succesful result" do
            { status, message } = Comporator.compare(json, schema)
            expect(status).to be :failure
            expect(message).to eq ~s(expected Jonh to be Jonh2)
          end
        end

        context "type comparison" do
          context "succesful type" do
            let :schema, do: %{ "name" => :string }

            it do: expect(
              Comporator.compare(json, schema)
            ).to be_true
          end

          context "unsuccesful type" do
            let :schema, do: %{ "name" => :integer }

            it do: expect(
              Comporator.compare(json, schema)
            ).to eq {:failure, ~s(expected "Jonh" to be a 'Integer' type)}
          end
        end

        context "use :symbol as schema key" do
          let :schema, do: %{ name: :string }

          it do: expect(
            Comporator.compare(json, schema)
          ).to be_true
        end

        context "use function as an expectation" do
          let :ends_with_onh? do
            fn(v)-> String.ends_with?(v, "onh") end
          end
          let :schema, do: %{ name: ends_with_onh? }

          it do: expect(
            Comporator.compare(json, schema)
          ).to be_true
        end
      end
    end
  end
end
