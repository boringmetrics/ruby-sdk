# frozen_string_literal: true

require_relative "boringmetrics/version"
require_relative "boringmetrics/client"
require_relative "boringmetrics/errors"

# Main module for the Boring Metrics SDK
module BoringMetrics
  class << self
    # @return [BoringMetrics::Client] The configured client instance
    attr_reader :instance

    # Initialize the SDK with your API token
    # @param token [String] Your Boring Metrics API token
    # @return [BoringMetrics::Client] The configured client instance
    def initialize(token)
      @instance ||= Client.new(token)
    end

    # Access logs functionality
    # @return [BoringMetrics::Client::LogMethods]
    def logs
      instance.logs
    end

    # Access lives functionality
    # @return [BoringMetrics::Client::LiveMethods]
    def lives
      instance.lives
    end
  end
end
