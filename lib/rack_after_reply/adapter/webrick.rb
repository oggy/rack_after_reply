module RackAfterReply
  module Adapter
    class WEBrick < Base
      def apply
        # Rack::Handler::WEBrick#service returns before the socket is closed,
        # and if we close it ourselves, WEBrick will close it again causing a
        # bomb. We can access the socket through the response argument, though,
        # so we hook into its #close method.
        Rack::Handler::WEBrick.module_eval do
          include RackAfterReply::RequestHandler

          def initialize_with_rack_after_reply(server, app)
            app = AppProxy.new(self, app)
            initialize_without_rack_after_reply(server, app)
          end
          RackAfterReply.freedom_patch self, :initialize

          def service_with_rack_after_reply(request, response)
            response.extend ResponseExtension
            response.rack_after_reply_handler = self
            service_without_rack_after_reply(request, response)
          end
          RackAfterReply.freedom_patch self, :service
        end
      end

      module ResponseExtension
        def send_response(socket)
          socket.extend SocketExtension
          socket.rack_after_reply_handler = rack_after_reply_handler
          super
        end

        attr_accessor :rack_after_reply_handler
      end

      module SocketExtension
        def close
          super
          rack_after_reply_handler.fire_rack_after_reply
        end

        attr_accessor :rack_after_reply_handler
      end
    end
  end
end
