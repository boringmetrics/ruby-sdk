# frozen_string_literal: true

module BoringMetrics
  # Methods for sending logs
  class LogMethods
    # Initialize the logs API
    #
    # @param client [BoringMetrics::Client] The client instance
    def initialize(client)
      @client = client
    end

    # Send a single log event
    #
    # @param log [Hash] The log event to send
    # @option log [String] :type The type of log (default: "log")
    # @option log [String] :level The log level (trace, debug, info, warn, error, fatal)
    # @option log [String] :message The log message
    # @option log [Hash] :data Additional structured data (optional)
    # @option log [String] :session_id Session identifier for grouping related logs (optional)
    # @option log [String] :sent_at ISO8601 date - will be automatically set if not provided
    # @return [void]
    def send(log)
      @client.add_log(log)
    end

    # Send multiple log events in a batch
    #
    # @param logs [Array<Hash>] Array of log events to send
    # @return [void]
    def send_batch(logs)
      logs.each { |log| send(log) }
    end
  end
end
