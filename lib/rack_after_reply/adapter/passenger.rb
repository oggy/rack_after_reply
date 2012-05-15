module RackAfterReply
  module Adapter
    class Passenger < Base
      def apply
        PhusionPassenger::Rack::RequestHandler.module_eval do
          include RackAfterReply::RequestHandler

          def initialize_with_rack_after_reply(owner_pipe, app, options = {})
            app = AppProxy.new(self, app)
            initialize_without_rack_after_reply(owner_pipe, app, options)
          end
          RackAfterReply.freedom_patch self, :initialize

          def accept_and_process_next_request_with_rack_after_reply(socket_wrapper, channel, buffer)
            response = accept_and_process_next_request_without_rack_after_reply(socket_wrapper, channel, buffer)
            fire_rack_after_reply
            response
          end
          RackAfterReply.freedom_patch self, :accept_and_process_next_request
        end
      end
    end
  end
end
