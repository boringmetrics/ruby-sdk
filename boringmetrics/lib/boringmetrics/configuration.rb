# frozen_string_literal: true

module BoringMetrics
  class Configuration
    attr_accessor :apiUrl, :maxRetryAttempts, :logsMaxBatchSize, :logsSendInterval, :livesMaxBatchSize, :livesDebounceTime

    def initialize
      @apiUrl = "https://api.getboringmetrics.com"
      @maxRetryAttempts = 5
      @logsMaxBatchSize = 100
      @logsSendInterval = 5 # seconds
      @livesMaxBatchSize = 20
      @livesDebounceTime = 1 # seconds
    end
  end
end
