# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grenache/version'

Gem::Specification.new do |spec|
  spec.name          = "grenache-ruby-base"
  spec.version       = Grenache::VERSION
  spec.email         = ["info@bitfinex.com"]

  spec.summary       = %q{Grenache Base Client implementation.}
  spec.homepage      = "https://github.com/bitfinexcom/grenache-ruby-base"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_bundler_dependencies
 # spec.add_development_dependency "bundler", "~> 1.9"
 # spec.add_development_dependency "rake", "~> 10.0"
 # spec.add_development_dependency "rspec", "~> 3.1.0"
 # spec.add_development_dependency "simplecov", "~> 0.11.0"
 # spec.add_runtime_dependency "eventmachine", "~> 1.0.9"
 # spec.add_runtime_dependency "faye-websocket", "~> 0.10.3"
 # spec.add_runtime_dependency "oj", "~> 2.1.0"
end
