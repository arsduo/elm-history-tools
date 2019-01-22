require "spec_helper"
require "json"

RSpec.describe ElmHistoryTools::HistorySanitizer do
  describe ".sanitize_history" do
    context "simple example" do
      let(:history_data) {
        {
          "a" => {
            "history" => [{"$" => "MySecretData", "a" => "access_token", "b" => {"password" => "myP@ssw0rd", "expiration" => "tomorrow"}}]
          }
        }
      }
      let(:watch_words) { ["MySecretData", "password"] }
      let(:sanitize) {
        Proc.new do |elm_object_or_record|
          if elm_object_or_record["$"] == "MySecretData"
            # replace the access token
            # make sure to return the updated object!
            elm_object_or_record.merge("a" =>"[FILTERED]")
          else
            # we have the record
            elm_object_or_record.merge("password" => "[FILTERED]")
          end
        end
      }

      it "sanitizes properly" do
        expect(
          ElmHistoryTools::HistorySanitizer.sanitize_history(history_data, watch_words, &sanitize)["a"]["history"]
        ).to eq(
          [{"$" => "MySecretData", "a" => "[FILTERED]", "b" => {"password" => "[FILTERED]", "expiration" => "tomorrow"}}]
        )
      end
    end

    context "real example" do
      let(:history_data) { JSON.parse(history_fixture) }
      # one constructor for an Elm type, one field in a record
      let(:watch_words) { ["NewQuote", "isbn"] }
      let(:sanitize) {
        Proc.new do |elm_object_or_record|
          if elm_object_or_record["$"].to_s =~ /NewQuote/
            elm_object_or_record.merge("a" => "[FILTERED]")
          else
            # it's an ISBN value in a record
            elm_object_or_record.each_with_object({}) do |(key, value), hash|
              hash[key] = (key == "isbn") ? "[FILTERED]" : value
            end
          end
        end
      }

      it "properly sanitizes a history" do
        expect(ElmHistoryTools::HistorySanitizer.sanitize_history(history_data, watch_words, &sanitize)["a"]["history"]).to eq([
          {"$"=>"BookListReceived",
           "a"=>
           {"$"=>"Ok",
            "a"=>
           {"$"=>"::",
            "a"=>
           {"id"=>1,
            "title"=>"The Book of the City of Ladies",
            "isbn"=>"[FILTERED]"},
           "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>2,
            "title"=>"Good Strategy, Bad Strategy",
            "isbn"=>"[FILTERED]"},
           "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>3,
            "title"=>"The Metamorphoses of Ovid",
            "isbn"=>"[FILTERED]"},
           "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>4, "title"=>"Parable of the Sower", "isbn"=>"[FILTERED]"},
             "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>5,
            "title"=>"Too Like the Lightning",
            "isbn"=>"[FILTERED]"},
           "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>6,
            "title"=>"The Fear of Barbarians",
            "isbn"=>"[FILTERED]"},
           "b"=>
           {"$"=>"::",
            "a"=>
           {"id"=>7,
            "title"=>"Evicted",
            "isbn"=>"[FILTERED]"}}}}}}}}}},
        {"$"=>"QuoteListReceived",
         "a"=>
           {"$"=>"Ok",
            "a"=>
           {"$"=>"::",
            "a"=>
           {"text"=>
            "I am amused how Reason, despite being a visitor from Heaven, keeps referencing a particular Italian writer as her source."},
              "b"=>
            {"$"=>"::",
             "a"=>
            {"text"=>
             "certain writers…maintain…the world was a better place before human beings learned more sophisticated ways and simply lived off acorns"},
               "b"=>
             {"$"=>"::",
              "a"=>
             {"text"=>
              "The idea that culture bad, state of nature good is thus at least 600 years old, and surely older."},
                "b"=>
              {"$"=>"::",
               "a"=>
              {"text"=>
               "Don't hesitate to mix the mortar well in your inkpot and set to on the masonry work with great strokes of your pen."},
                 "b"=>
               {"$"=>"::",
                "a"=>
               {"text"=>
                "I can't tell if the author truly believes good upbringing will lead to dutiful children or if it's just what one had to write back then. "},
                  "b"=>
                {"$"=>"::",
                 "a"=>{"text"=>"A new Realm of Femininia is at hand"},
                 "b"=>
                {"$"=>"::",
                 "a"=>
                {"text"=>
                 "Another misogynist idea that's over 600 years old: women  cause trouble, lack affection, and gossip incessantly."},
                   "b"=>
                 {"$"=>"::",
                  "a"=>
                 {"text"=>
                  "This translation uses the word werewolf, but the Latin is literally ambiguous wolf. 🐺\u{1F937}"}}}}}}}}}}},
           {"$"=>"BookChosen",
            "a"=>{"id"=>5, "title"=>"Too Like the Lightning", "isbn"=>"[FILTERED]"}},
                  {"$"=>"QuoteListReceived",
                   "a"=>
                  {"$"=>"Ok",
                   "a"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>48},
                   "text"=>
                  "that desperate Middle Age when images were objects of utility more than art.",
                    "page"=>{"$"=>"Just", "a"=>"232"},
                    "kind"=>{"$"=>"DirectQuote"},
                    "bookId"=>5},
                    "b"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>49},
                   "text"=>
                  "One of the most striking aspects to this book's world is how alien the flows of information and trust are. It's coherent, just alien.",
                    "page"=>{"$"=>"Just", "a"=>"161"},
                    "kind"=>{"$"=>"Thought"},
                    "bookId"=>5},
                    "b"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>54},
                   "text"=>"the disapproval of a nun is extremely powerful",
                   "page"=>{"$"=>"Just", "a"=>"304"},
                   "kind"=>{"$"=>"DirectQuote"},
                   "bookId"=>5},
                   "b"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>55},
                   "text"=>
                  "Celibacy is the most extreme of sexual perversions.",
                    "page"=>{"$"=>"Just", "a"=>"305"},
                    "kind"=>{"$"=>"DirectQuote"},
                    "bookId"=>5},
                    "b"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>56},
                   "text"=>
                  "lips which had tasted many vitamins but never candy",
                    "page"=>{"$"=>"Just", "a"=>"357"},
                    "kind"=>{"$"=>"DirectQuote"},
                    "bookId"=>5},
                    "b"=>
                  {"$"=>"::",
                   "a"=>
                  {"id"=>{"$"=>"Just", "a"=>57},
                   "text"=>
                  "words with only one chance to persuade, or fail and perish",
                    "page"=>{"$"=>"Just", "a"=>"358"},
                    "kind"=>{"$"=>"DirectQuote"},
                    "bookId"=>5},
                    "b"=>{"$"=>"[]"}}}}}}}}},
                  {"$"=>"NewQuoteTextEntered", "a"=>"[FILTERED]"},
                  {"$"=>"NewQuoteTextEntered", "a"=>"[FILTERED]"},
                  {"$"=>"NewQuoteTextEntered", "a"=>"[FILTERED]"}
        ])
      end
    end
  end
end