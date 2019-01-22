require "spec_helper"

RSpec.describe ElmHistoryTools::Utils do
  describe ".transform_object" do
    let(:sample_object) {
      {
        "$" => "TestMessage",
        "a" => "a primitive value",
        "b" => {
          "type" => "record",
          "containing" => {
            "$" => "AnObject",
            "a" => "SomeValue"
          }
        },
        "c" => {
          "$" => "AnotherObject"
        }
      }
    }

    it "transforms the entry according to the block provided" do
      transformation = lambda do |object_hash|
        object_hash = object_hash.each_with_object({}) do |(k, v), hash|
          if k == "$"
            hash["constru$"] = v
          else
            hash[k.upcase + "processed"] = ElmHistoryTools::Utils.transform_object(v, &transformation)
          end
        end
      end

      result = ElmHistoryTools::Utils.transform_object(sample_object, &transformation)

      expect(result).to eq({
        "constru$" => "TestMessage",
        "Aprocessed" => "a primitive value",
        "Bprocessed" => {
          # records are handled differently than objects
          "type" => "record",
          "containing" => {
            # this shows that embedded objects are also processed
            "constru$" => "AnObject",
            "Aprocessed" => "SomeValue"
          }
        },
        "Cprocessed" => {
          "constru$" => "AnotherObject"
        }
      })
    end
  end
end
