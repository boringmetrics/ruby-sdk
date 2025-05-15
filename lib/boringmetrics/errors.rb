# frozen_string_literal: true

module BoringMetrics
  class Error < StandardError; end
  class ConfigurationError < Error; end
  class APIError < Error; end
end