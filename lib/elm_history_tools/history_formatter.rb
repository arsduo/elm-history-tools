module ElmHistoryTools::HistoryFormatter
  # Given a raw Elm history file parsed to JSON, return a simplified hash of the history.
  #
  # For instance, given an array like:
  # [{"$": "MessageType", "a": "Arg1", "a2": {"$": "AnotherType"}}]
  #
  # you'll get
  #
  # [{"MessageType" => ["Arg1", {"AnotherType" => []}]}]
  #
  def self.to_simple_hash(history_data)
    history_data.dig("a", "history").map do |entry|
      simplify_history_entry(entry)
    end
  end

  # Turn an Elm history entry into a simple Ruby hash, as described above.
  #
  # Constru$s that take no arguments are represented as taking an empty list (see above); an
  # alternative approach would be to use nil. While that would clearly distinguish between those
  # cases, it would make working with the results more complicated.
  def self.simplify_history_entry(entry)
    ElmHistoryTools::Utils.transform_object(entry) do |object_hash|
      if object_hash["$"] == "::"
        # Elm lists are represented as nested entries with the contru$ ::. (See the readme for
        # more detail.)
        # We collapse those into a proper Ruby array via flatten.
        # The last entry of the list will have no nested entry, so we use compact to remove the nil.
        [simplify_history_entry(object_hash["a"]), simplify_history_entry(object_hash["b"])].compact.flatten
      elsif object_hash["$"]
        # we have an Elm object type (we know this because non-objects aren't passed to the block)
        {
          object_hash["$"] => object_hash.reject {|k, _v| k == "$"}.values.map {|val| simplify_history_entry(val) }
        }
      end
    end
  end

  class << self
    private :simplify_history_entry
  end
end
