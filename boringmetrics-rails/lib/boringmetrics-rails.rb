# frozen_string_literal: true

require "boringmetrics"
require_relative "boringmetrics-rails/version"
require_relative "boringmetrics-rails/railtie"

module BoringMetrics
  # Rails integration for BoringMetrics
  module Rails
    class << self
      # Initialize the SDK with Rails integration
      #
      # @param token [String] Your BoringMetrics API token
      # @param config [Hash] Optional configuration options
      # @return [BoringMetrics::Client] The initialized client
      def initialize(token, **config)
        BoringMetrics.initialize(token, **config)
      end
    end
  end
end
