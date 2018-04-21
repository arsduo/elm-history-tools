
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "elm_history_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "elm_history_tools"
  spec.version       = ElmHistoryTools::VERSION
  spec.authors       = ["Alex Koppel"]
  spec.email         = ["alex@alexkoppel.com"]

  spec.summary       = %q{Tools to work with Elm history exports.}
  spec.homepage      = "http://github.com/arsduo/elm-history-tools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
