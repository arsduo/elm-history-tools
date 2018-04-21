module ElmHistoryTools::HistoryFormatter
  # Given a raw Elm history file parsed to JSON, return a simplified hash of the history.
  #
  # For instance, given an array like:
  # [{"ctor": "MessageType", "_0": "Arg1", "_02": {"ctor": "AnotherType"}}]
  #
  # you'll get
  #
  # [{"MessageType" => ["Arg1", {"AnotherType" => []}]}]
  #
  def self.to_simple_hash(history_data)
    history_data["history"].map do |entry|
      simplify_history_entry(entry)
    end
  end

  # Turn an Elm history entry into a simple Ruby hash, as described above.
  #
  # Constructors that take no arguments are represented as taking an empty list (see above); an
  # alternative approach would be to use nil. While that would clearly distinguish between those
  # cases, it would make working with the results more complicated.
  def self.simplify_history_entry(entry)
    if !entry.is_a?(Hash)
      entry
    elsif entry["ctor"] == "::"
      # Elm lists are represented as nested entries with the contructor ::. (See the readme for
      # more detail.)
      # We collapse those into a proper Ruby array via flatten.
      # The last entry of the list will have no nested entry, so we use compact to remove the nil.
      [simplify_history_entry(entry["_0"]), simplify_history_entry(entry["_1"])].compact.flatten
    elsif entry["ctor"]
      # we have an Elm type
      {
        entry["ctor"] => entry.reject {|k, _v| k == "ctor"}.values.map {|val| simplify_history_entry(val) }
      }
    else
      entry.each_with_object({}) do |(key, value), hash|
        hash[key] = simplify_history_entry(value)
      end
    end
  end
end
