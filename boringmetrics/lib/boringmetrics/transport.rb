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
      # Convert from Ruby style to camelCase for API
      api_logs = logs.map do |log|
        api_log = {}
        log.each do |key, value|
          case key.to_s
          when "sent_at"
            api_log[:sentAt] = value
          when "session_id"
            api_log[:sessionId] = value
          else
            api_log[key] = value
          end
        end
        api_log
      end

      with_retry do
        response = connection.post("/api/v1/logs") do |req|
          req.headers["Content-Type"] = "application/json"
          req.headers["Authorization"] = "Bearer #{@config.token}"
          req.body = { logs: api_logs }.to_json
        end

        raise "Failed to send logs: #{response.status}" unless response.success?
      end
    end

    # Update a live metric
    #
    # @param update [Hash] The live update to send
    # @return [void]
    def update_live(update)
      # Convert from Ruby style to camelCase for API
      api_update = {}
      update.each do |key, value|
        case key.to_s
        when "live_id"
          api_update[:liveId] = value
        when "sent_at"
          api_update[:sentAt] = value
        else
          api_update[key] = value
        end
      end

      with_retry do
        live_id = update[:live_id] || update[:liveId]
        response = connection.put("/api/v1/lives/#{live_id}") do |req|
          req.headers["Content-Type"] = "application/json"
          req.headers["Authorization"] = "Bearer #{@config.token}"
          req.body = { live: api_update }.to_json
        end

        raise "Failed to send live update: #{response.status}" unless response.success?
      end
    end

    private

    def connection
      @connection ||= Faraday.new(url: @config.apiUrl) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
    end

    def with_retry
      retries = 0
      begin
        yield
      rescue StandardError => e
        retries += 1
        if retries <= @config.maxRetryAttempts
          sleep(2**retries * 0.1) # Exponential backoff
          retry
        else
          raise e
        end
      end
    end
  end
end
