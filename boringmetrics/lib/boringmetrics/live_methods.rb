# frozen_string_literal: true

module BoringMetrics
  # Methods for updating live metrics
  class LiveMethods
    # Initialize the lives API
    #
    # @param client [BoringMetrics::Client] The client instance
    def initialize(client)
      @client = client
    end

    # Update a live metric value
    #
    # @param update [Hash] The live update to send
    # @option update [String] :live_id The ID of the live metric
    # @option update [Numeric] :value The value to set or increment
    # @option update [String] :operation The operation to perform ("set" or "increment")
    # @option update [String] :sent_at ISO8601 date - will be automatically set if not provided
    # @return [void]
    def update(update)
      @client.update_live(update)
    end

    # Update multiple live metrics values in a batch
    #
    # @param updates [Array<Hash>] Array of live updates to send
    # @return [void]
    def update_batch(updates)
      updates.each { |update| update(update) }
    end
  end
end
