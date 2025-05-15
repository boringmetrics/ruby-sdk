# frozen_string_literal: true

require_relative "lib/boringmetrics/version"

Gem::Specification.new do |spec|
  spec.name = "boringmetrics"
  spec.version = BoringMetrics::VERSION
  spec.authors = ["Aymeric Chauvin"]
  spec.email = ["contact@halftheopposite.dev"]

  spec.summary = "Ruby SDK for Boring Metrics"
  spec.description = "Ruby SDK for the Boring Metrics API. It provides a simple and efficient way to interact with the API from your Ruby applications."
  spec.homepage = "https://github.com/boringmetrics/ruby-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/boringmetrics/ruby-sdk"
  spec.metadata["changelog_uri"] = "https://github.com/boringmetrics/ruby-sdk/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.glob("lib/**/*") + ["README.md", "LICENSE", "CHANGELOG.md"].select { |f| File.exist?(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "concurrent-ruby", "~> 1.2"
  spec.add_dependency "faraday", "~> 2.7"

  # Development dependencies
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
