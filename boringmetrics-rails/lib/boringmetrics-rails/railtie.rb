# frozen_string_literal: true

require "rails"
require_relative "middleware"

module BoringMetrics
  module Rails
    # Rails integration for BoringMetrics
    class Railtie < ::Rails::Railtie
      initializer "boringmetrics.middleware" do |app|
        app.middleware.use Middleware
      end

      # Log Rails errors to BoringMetrics
      config.after_initialize do
        ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
          event = ActiveSupport::Notifications::Event.new(*args)
          exception = event.payload[:exception_object]

          if exception && defined?(BoringMetrics.client) && BoringMetrics.client
            BoringMetrics.logs.send(
              type: "log",
              level: "error",
              message: exception.message,
              data: {
                exception: exception.class.name,
                backtrace: exception.backtrace&.first(10),
                controller: event.payload[:controller],
                action: event.payload[:action]
              }
            )
          end
        end
      end
    end
  end
end
