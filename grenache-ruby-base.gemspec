# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grenache/version'

Gem::Specification.new do |spec|
  spec.name          = "grenache-ruby-base"
  spec.version       = Grenache::VERSION
  spec.email         = ["info@bitfinex.com"]
  spec.author        = "Bitfinex"

  spec.summary       = %q{Grenache Base Client implementation.}
  spec.homepage      = "https://github.com/bitfinexcom/grenache-ruby-base"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "eventmachine", "~> 1.2"
  spec.add_runtime_dependency "faye-websocket", "~> 0.10"
  spec.add_runtime_dependency "oj", "~> 3.6"
  spec.add_runtime_dependency "httparty", "~> 0.22.0"

  spec.add_development_dependency "rspec", "~> 3.5"
end
