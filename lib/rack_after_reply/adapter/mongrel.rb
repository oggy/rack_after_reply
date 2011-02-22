module RackAfterReply
  module Adapter
    class Mongrel < Base
      def apply
        Rack::Handler::Mongrel.module_eval do
          include RackAfterReply::RequestHandler

          def initialize_with_rack_after_reply(app)
            app = AppProxy.new(self, app)
            initialize_without_rack_after_reply(app)
          end
          RackAfterReply.freedom_patch self, :initialize

          def process_with_rack_after_reply(request, response)
            process_without_rack_after_reply(request, response)
          ensure
            response.socket.close
            fire_rack_after_reply
          end
          RackAfterReply.freedom_patch self, :process
        end
      end
    end
  end
end
