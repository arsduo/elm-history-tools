module ElmHistoryTools::Utils
  # This method gives us a tool to walk down an Elm history entry, processing all the Elm objects contained within per the provided block. Whatever the block returns will become the value at that point.
  #
  # To simplify matters, this doesn't process primitive values. Additionally, while each value an
  # Elm record (which are stored as plain JSON objects) is examined, the overall record itself is
  # never passed to the block -- to examine/alter an Elm record, do so in the callback for
  # whichever Elm object contains it. (All history entries are Message objects, so there's always
  # an entry point.)
  def self.transform_object(entry, &block)
    if !entry.is_a?(Hash)
      entry
    elsif entry["$"]
      # If you want to walk down sub-entries, call transform_object within your block.
      yield entry
    else
      # Each Elm record should be
      entry.each_with_object({}) do |(key, value), hash|
        hash[key] = transform_object(value, &block)
      end
    end
  end
end
