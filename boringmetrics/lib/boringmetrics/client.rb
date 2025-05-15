# frozen_string_literal: true

require "concurrent"
require "time"

module BoringMetrics
  # Main client for the BoringMetrics SDK
  class Client
    attr_reader :logs, :lives

    # Initialize a new client
    #
    # @param token [String] Your BoringMetrics API token
    # @param config [Hash] Optional configuration options
    def initialize(token, **config)
      @config = Configuration.new(token, **config)
      @transport = Transport.new(@config)

      @logs_queue = Concurrent::Array.new
      @logs_mutex = Mutex.new
      @logs_timer = nil

      @lives_queue = Concurrent::Array.new
      @lives_mutex = Mutex.new
      @lives_timer = nil

      @logs = LogMethods.new(self)
      @lives = LiveMethods.new(self)
    end

    # Add a log to the queue
    #
    # @param log [Hash] The log to add
    # @return [void]
    def add_log(log)
      log_with_sent_at = log.dup

      # Support both snake_case and camelCase
      if log_with_sent_at[:sentAt].nil? && log_with_sent_at[:sent_at].nil?
        log_with_sent_at[:sentAt] = Time.now.iso8601
      elsif log_with_sent_at[:sent_at] && log_with_sent_at[:sentAt].nil?
        log_with_sent_at[:sentAt] = log_with_sent_at[:sent_at]
      end

      @logs_mutex.synchronize do
        @logs_queue << log_with_sent_at

        if @logs_queue.size >= @config.logsMaxBatchSize
          flush_logs
        elsif @logs_timer.nil?
          schedule_logs_flush
        end
      end
    end

    # Update a live metric
    #
    # @param update [Hash] The live update
    # @return [void]
    def update_live(update)
      update_with_sent_at = update.dup

      # Support both snake_case and camelCase
      if update_with_sent_at[:sentAt].nil? && update_with_sent_at[:sent_at].nil?
        update_with_sent_at[:sentAt] = Time.now.iso8601
      elsif update_with_sent_at[:sent_at] && update_with_sent_at[:sentAt].nil?
        update_with_sent_at[:sentAt] = update_with_sent_at[:sent_at]
      end

      @lives_mutex.synchronize do
        @lives_queue << update_with_sent_at

        if @lives_queue.size >= @config.livesMaxBatchSize
          flush_lives
        elsif @lives_timer.nil?
          schedule_lives_flush
        end
      end
    end

    private

    def schedule_logs_flush
      @logs_timer = Concurrent::ScheduledTask.execute(@config.logsSendInterval) do
        flush_logs
      end
    end

    def flush_logs
      @logs_mutex.synchronize do
        @logs_timer&.cancel
        @logs_timer = nil

        return if @logs_queue.empty?

        logs_to_send = @logs_queue.dup
        @logs_queue.clear

        send_logs(logs_to_send)
      end
    end

    def send_logs(logs)
      Thread.new do
        begin
          @transport.send_logs(logs)
        rescue StandardError => e
          puts "[BoringMetrics] Error sending logs: #{e.message}"
        end
      end
    end

    def schedule_lives_flush
      @lives_timer = Concurrent::ScheduledTask.execute(@config.livesDebounceTime) do
        flush_lives
      end
    end

    def flush_lives
      @lives_mutex.synchronize do
        @lives_timer&.cancel
        @lives_timer = nil

        return if @lives_queue.empty?

        lives_to_send = @lives_queue.dup
        @lives_queue.clear

        send_lives(lives_to_send)
      end
    end

    def send_lives(lives)
      Thread.new do
        begin
          lives.each do |live|
            @transport.update_live(live)
          end
        rescue StandardError => e
          puts "[BoringMetrics] Error sending live updates: #{e.message}"
        end
      end
    end
  end
end
