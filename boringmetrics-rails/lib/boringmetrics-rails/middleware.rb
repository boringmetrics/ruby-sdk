# frozen_string_literal: true

module BoringMetrics
  module Rails
    # Rack middleware for BoringMetrics
    class Middleware
      def initialize(app)
        @app = app
      end

      def call(env)
        start_time = Time.now

        # Process the request
        begin
          status, headers, response = @app.call(env)
          [status, headers, response]
        rescue StandardError => e
          # Log the exception if BoringMetrics is initialized
          if defined?(BoringMetrics.client) && BoringMetrics.client
            BoringMetrics.logs.send(
              type: "log",
              level: "error",
              message: e.message,
              data: {
                exception: e.class.name,
                backtrace: e.backtrace&.first(10),
                path: env["PATH_INFO"],
                method: env["REQUEST_METHOD"]
              }
            )
          end
          raise e
        ensure
          # Log request metrics if BoringMetrics is initialized
          if defined?(BoringMetrics.client) && BoringMetrics.client
            duration = ((Time.now - start_time) * 1000).round(2) # in milliseconds

            # Update live metric for request duration
            BoringMetrics.lives.update(
              liveId: "request_duration",
              value: duration,
              operation: "set"
            )
          end
        end
      end
    end
  end
end
