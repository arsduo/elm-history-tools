require "spec_helper"
require "json"

RSpec.describe ElmHistoryTools::HistorySanitizer do
  let(:history_data) { JSON.parse(history_fixture) }

  describe ".sanitize_history" do
    # one constructor, one record
    let(:watch_words) { ["NewQuote", "isbn"] }
    let(:sanitize) {
      Proc.new do |elm_object_or_record|
        if elm_object_or_record["ctor"].to_s =~ /NewQuote/
          elm_object_or_record.merge("_0" => "[FILTERED]")
        else
          # it's an ISBN value in a record
          elm_object_or_record.each_with_object({}) do |(key, value), hash|
            hash[key] = (key == "isbn") ? "[FILTERED]" : value
          end
        end
      end
    }

    it "properly sanitizes a history" do
      expect(ElmHistoryTools::HistorySanitizer.sanitize_history(history_data, watch_words, &sanitize)["history"]).to eq([
        {"ctor"=>"BookListReceived",
         "_0"=>
         {"ctor"=>"Ok",
          "_0"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>1,
          "title"=>"The Book of the City of Ladies",
          "isbn"=>"[FILTERED]"},
         "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>2,
          "title"=>"Good Strategy, Bad Strategy",
          "isbn"=>"[FILTERED]"},
         "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>3,
          "title"=>"The Metamorphoses of Ovid",
          "isbn"=>"[FILTERED]"},
         "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>4, "title"=>"Parable of the Sower", "isbn"=>"[FILTERED]"},
           "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>5,
          "title"=>"Too Like the Lightning",
          "isbn"=>"[FILTERED]"},
         "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>6,
          "title"=>"The Fear of Barbarians",
          "isbn"=>"[FILTERED]"},
         "_1"=>
         {"ctor"=>"::",
          "_0"=>
         {"id"=>7,
          "title"=>"Evicted",
          "isbn"=>"[FILTERED]"}}}}}}}}}},
      {"ctor"=>"QuoteListReceived",
       "_0"=>
         {"ctor"=>"Ok",
          "_0"=>
         {"ctor"=>"::",
          "_0"=>
         {"text"=>
          "I am amused how Reason, despite being a visitor from Heaven, keeps referencing a particular Italian writer as her source."},
            "_1"=>
          {"ctor"=>"::",
           "_0"=>
          {"text"=>
           "\"certain writers…maintain…the world was a better place before human beings learned more sophisticated ways and simply lived off acorns\" "},
             "_1"=>
           {"ctor"=>"::",
            "_0"=>
           {"text"=>
            "The idea that culture bad, state of nature good is thus at least 600 years old, and surely older."},
              "_1"=>
            {"ctor"=>"::",
             "_0"=>
            {"text"=>
             "\"Don't hesitate to mix the mortar well in your inkpot and set to on the masonry work with great strokes of your pen.\""},
               "_1"=>
             {"ctor"=>"::",
              "_0"=>
             {"text"=>
              "I can't tell if the author truly believes good upbringing will lead to dutiful children or if it's just what one had to write back then. "},
                "_1"=>
              {"ctor"=>"::",
               "_0"=>{"text"=>"\"A new Realm of Femininia is at hand\""},
               "_1"=>
              {"ctor"=>"::",
               "_0"=>
              {"text"=>
               "Another misogynist idea that's over 600 years old: women \" cause trouble, lack affection, and gossip incessantly\"."},
                 "_1"=>
               {"ctor"=>"::",
                "_0"=>
               {"text"=>
                "This translation uses the word \"werewolf\", but the Latin is literally \"ambiguous wolf.\" 🐺\u{1F937}"}}}}}}}}}}},
         {"ctor"=>"BookChosen",
          "_0"=>{"id"=>5, "title"=>"Too Like the Lightning", "isbn"=>"[FILTERED]"}},
                {"ctor"=>"QuoteListReceived",
                 "_0"=>
                {"ctor"=>"Ok",
                 "_0"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>48},
                 "text"=>
                "\"that desperate Middle Age when images were objects of utility more than art.\"",
                  "page"=>{"ctor"=>"Just", "_0"=>"232"},
                  "kind"=>{"ctor"=>"DirectQuote"},
                  "bookId"=>5},
                  "_1"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>49},
                 "text"=>
                "One of the most striking aspects to this book's world is how alien the flows of information and trust are. It's coherent, just alien.",
                  "page"=>{"ctor"=>"Just", "_0"=>"161"},
                  "kind"=>{"ctor"=>"Thought"},
                  "bookId"=>5},
                  "_1"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>54},
                 "text"=>"\"the disapproval of a nun is extremely powerful\"",
                 "page"=>{"ctor"=>"Just", "_0"=>"304"},
                 "kind"=>{"ctor"=>"DirectQuote"},
                 "bookId"=>5},
                 "_1"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>55},
                 "text"=>
                "\"Celibacy is the most extreme of sexual perversions.\"",
                  "page"=>{"ctor"=>"Just", "_0"=>"305"},
                  "kind"=>{"ctor"=>"DirectQuote"},
                  "bookId"=>5},
                  "_1"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>56},
                 "text"=>
                "\"lips which had tasted many vitamins but never candy\"",
                  "page"=>{"ctor"=>"Just", "_0"=>"357"},
                  "kind"=>{"ctor"=>"DirectQuote"},
                  "bookId"=>5},
                  "_1"=>
                {"ctor"=>"::",
                 "_0"=>
                {"id"=>{"ctor"=>"Just", "_0"=>57},
                 "text"=>
                "\"words with only one chance to persuade, or fail and perish\"",
                  "page"=>{"ctor"=>"Just", "_0"=>"358"},
                  "kind"=>{"ctor"=>"DirectQuote"},
                  "bookId"=>5},
                  "_1"=>{"ctor"=>"[]"}}}}}}}}},
                {"ctor"=>"NewQuoteTextEntered", "_0"=>"[FILTERED]"},
                {"ctor"=>"NewQuoteTextEntered", "_0"=>"[FILTERED]"},
                {"ctor"=>"NewQuoteTextEntered", "_0"=>"[FILTERED]"}
      ])
    end
  end
end