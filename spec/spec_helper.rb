# Tools
require "byebug"

# The library
require "elm_history_tools"

def history_fixture
  File.read(File.join(File.dirname(__FILE__), "fixtures", "elm-history.txt"))
end
