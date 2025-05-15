# frozen_string_literal: true

require "faraday"
require "json"

module BoringMetrics
  # Transport layer for the BoringMetrics SDK
  class Transport
    # Initialize a new transport
    #
    # @param config [BoringMetrics::Configuration] The SDK configuration
    def initialize(config)
      @config = config
    end

    # Send logs to the BoringMetrics API
    #
    # @param logs [Array<Hash>] The logs to send
    # @return [void]
    def send_logs(logs)
      with_retry do
        response = connection.post("/api/v1/logs") do |req|
          req.headers["Content-Type"] = "application/json"
          req.headers["Authorization"] = "Bearer #{@config.token}"
          req.body = { logs: logs }.to_json
        end

        raise "Failed to send logs: #{response.status}" unless response.success?
      end
    end

    # Update a live metric
    #
    # @param update [Hash] The live update to send
    # @return [void]
    def update_live(update)
      with_retry do
        response = connection.put("/api/v1/lives/#{update[:live_id]}") do |req|
          req.headers["Content-Type"] = "application/json"
          req.headers["Authorization"] = "Bearer #{@config.token}"
          req.body = { live: update }.to_json
        end

        raise "Failed to send live update: #{response.status}" unless response.success?
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: Configuration::API_URL) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def with_retry
      retries = 0
      begin
        yield
      rescue StandardError => e
        retries += 1
        if retries <= @config.max_retry_attempts
          sleep(2**retries * 0.1) # Exponential backoff
          retry
        else
          raise e
        end
      end
    end
  end
end
