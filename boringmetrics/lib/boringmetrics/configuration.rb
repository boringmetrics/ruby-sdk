# frozen_string_literal: true

module BoringMetrics
  class Configuration
    attr_accessor :api_url, :max_retry_attempts, :logs_max_batch_size, :logs_send_interval
    
    def initialize
      @api_url = "https://api.getboringmetrics.com"
      @max_retry_attempts = 5
      @logs_max_batch_size = 100
      @logs_send_interval = 5 # seconds
    end
  end
end
