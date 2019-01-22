require "spec_helper"
require "json"

RSpec.describe ElmHistoryTools::HistoryFormatter do
  let(:history_data) { JSON.parse(history_fixture) }

  describe ".to_simple_hash" do
    it "properly formats a history hash" do
      expect(ElmHistoryTools::HistoryFormatter.to_simple_hash(history_data)). to eq(
        [{"BookListReceived"=>
           [{"Ok"=>
              [[{"id"=>1,
                 "title"=>"The Book of the City of Ladies",
                 "isbn"=>"0140446893"},
                {"id"=>2,
                 "title"=>"Good Strategy, Bad Strategy",
                 "isbn"=>"9780307886231"},
                {"id"=>3,
                 "title"=>"The Metamorphoses of Ovid",
                 "isbn"=>"9780156001267"},
                {"id"=>4, "title"=>"Parable of the Sower", "isbn"=>"9780446675505"},
                {"id"=>5, "title"=>"Too Like the Lightning", "isbn"=>"9780765378019"},
                {"id"=>6, "title"=>"The Fear of Barbarians", "isbn"=>"97802268065757"},
                {"id"=>7, "title"=>"Evicted", "isbn"=>"9780553447453"}]]}]},
         {"QuoteListReceived"=>
           [{"Ok"=>
              [[{"text"=>
                  "I am amused how Reason, despite being a visitor from Heaven, keeps referencing a particular Italian writer as her source."},
                {"text"=>
                  "certain writers…maintain…the world was a better place before human beings learned more sophisticated ways and simply lived off acorns"},
                {"text"=>
                  "The idea that culture bad, state of nature good is thus at least 600 years old, and surely older."},
                {"text"=>
                  "Don't hesitate to mix the mortar well in your inkpot and set to on the masonry work with great strokes of your pen."},
                {"text"=>
                  "I can't tell if the author truly believes good upbringing will lead to dutiful children or if it's just what one had to write back then. "},
                {"text"=>"A new Realm of Femininia is at hand"},
                {"text"=>
                  "Another misogynist idea that's over 600 years old: women  cause trouble, lack affection, and gossip incessantly."},
                {"text"=>
                  "This translation uses the word werewolf, but the Latin is literally ambiguous wolf. 🐺\u{1F937}"}]]}]},
         {"BookChosen"=>
           [{"id"=>5, "title"=>"Too Like the Lightning", "isbn"=>"9780765378019"}]},
         {"QuoteListReceived"=>
           [{"Ok"=>
              [[{"id"=>{"Just"=>[48]},
                 "text"=>
                  "that desperate Middle Age when images were objects of utility more than art.",
                 "page"=>{"Just"=>["232"]},
                 "kind"=>{"DirectQuote"=>[]},
                 "bookId"=>5},
                {"id"=>{"Just"=>[49]},
                 "text"=>
                  "One of the most striking aspects to this book's world is how alien the flows of information and trust are. It's coherent, just alien.",
                 "page"=>{"Just"=>["161"]},
                 "kind"=>{"Thought"=>[]},
                 "bookId"=>5},
                {"id"=>{"Just"=>[54]},
                 "text"=>"the disapproval of a nun is extremely powerful",
                 "page"=>{"Just"=>["304"]},
                 "kind"=>{"DirectQuote"=>[]},
                 "bookId"=>5},
                {"id"=>{"Just"=>[55]},
                 "text"=>"Celibacy is the most extreme of sexual perversions.",
                 "page"=>{"Just"=>["305"]},
                 "kind"=>{"DirectQuote"=>[]},
                 "bookId"=>5},
                {"id"=>{"Just"=>[56]},
                 "text"=>"lips which had tasted many vitamins but never candy",
                 "page"=>{"Just"=>["357"]},
                 "kind"=>{"DirectQuote"=>[]},
                 "bookId"=>5},
                {"id"=>{"Just"=>[57]},
                 "text"=>
                  "words with only one chance to persuade, or fail and perish",
                 "page"=>{"Just"=>["358"]},
                 "kind"=>{"DirectQuote"=>[]},
                 "bookId"=>5},
                {"[]"=>[]}]]}]},
         {"NewQuoteTextEntered"=>["a"]},
         {"NewQuoteTextEntered"=>["ab"]},
         {"NewQuoteTextEntered"=>["abc"]}]
      )
    end
  end
end
