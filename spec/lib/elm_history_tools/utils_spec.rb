require "spec_helper"

RSpec.describe ElmHistoryTools::Utils do
  describe ".transform_object" do
    let(:sample_object) {
      {
        "ctor" => "TestMessage",
        "_0" => "a primitive value",
        "_1" => {
          "type" => "record",
          "containing" => {
            "ctor" => "AnObject",
            "_0" => "SomeValue"
          }
        },
        "_2" => {
          "ctor" => "AnotherObject"
        }
      }
    }

    it "transforms the entry according to the block provided" do
      transformation = lambda do |object_hash|
        object_hash = object_hash.each_with_object({}) do |(k, v), hash|
          if k == "ctor"
            hash["constructor"] = v
          else
            hash[k.upcase + "processed"] = ElmHistoryTools::Utils.transform_object(v, &transformation)
          end
        end
      end

      result = ElmHistoryTools::Utils.transform_object(sample_object, &transformation)

      expect(result).to eq({
        "constructor" => "TestMessage",
        "_0processed" => "a primitive value",
        "_1processed" => {
          # records are handled differently than objects
          "type" => "record",
          "containing" => {
            # this shows that embedded objects are also processed
            "constructor" => "AnObject",
            "_0processed" => "SomeValue"
          }
        },
        "_2processed" => {
          "constructor" => "AnotherObject"
        }
      })
    end
  end
end
