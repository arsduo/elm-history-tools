module ElmHistoryTools::HistorySanitizer
  # We don't include the object received because it might have sensitive information
  # This might be reconsidered in the future.
  class ElmObjectExpected < StandardError; end

  # Given a raw Elm history file parsed to JSON, a set of key terms to watch for (password, token,
  # etc.) , sanitize a
  # history so it doesn't contain sensitive information.
  #
  # The message sanitizers should be in the format of
  # "HistoryConstructor" => block_taking_history_entry_and_returning_sanitized_version
  #
  # You can optionally specify a set of watch words to ensure you don't accidentally
  # introduce unsafe data. If specified and any unsanitized entry contains a constructor or record
  # property matching one of those words, an error will be raised. (So for instance, if you add a
  # User object with an Password property to a message, a watch word for "password" will catch
  # that -- though it would also catch password_reset_requested.)
  #
  # Each app will have such different entry structures that there's no easy to generalize this
  # further.
  def self.sanitize_history(history_data, watch_words, &sanitizing_block)
    matchers = watch_words.map {|word| word.is_a?(Regexp) ? word : Regexp.new(word, true)}
    data = history_data.dup
    data["a"].merge!(
      "history" => data["a"]["history"].map {|entry| sanitize(entry, matchers, &sanitizing_block)}
    )
    data
  end

  # For each entry, we sanitize it if there's a matching handler. If there is no sanitizer, see if
  # any data in the entry merit flagging against a watch word.
  def self.sanitize(entry, matchers, &sanitizing_block)
    ElmHistoryTools::Utils.transform_object(entry) do |elm_object|
      constructor = elm_object["$"]
      raise ElmObjectExpected unless constructor

      # replace any records that need it
      cleaned_object = elm_object.each_with_object({}) do |(key, value), hash|
        if value.is_a?(Hash) && value["$"]
          # we have an elm object -- sanitize that
          hash[key] = sanitize(value, matchers, &sanitizing_block)
        elsif value.is_a?(Hash)
          # We have an Elm record, represented as a raw hash
          # This is inefficient, but should hopefully be acceptable for the relatively low number of records
          # being processed. If not, we can rewrite it.
          if value.keys.any? {|field| matchers.any? {|matcher| field.match(matcher)}}
            hash[key] = yield value
          else
            hash[key] = value
          end
        else
          # raw values
          hash[key] = value
        end
      end

      # now that we've sanitized any stored records or objects, sanitize the overall record
      if matchers.any? {|matcher| constructor.match(matcher)}
        yield cleaned_object
      else
        cleaned_object
      end
    end
  end

  class << self
    private :sanitize
  end
end

