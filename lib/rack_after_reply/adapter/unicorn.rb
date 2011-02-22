module RackAfterReply
  module Adapter
    class Unicorn < Base
      def apply
        ::Unicorn::HttpServer.module_eval do
          include RackAfterReply::RequestHandler

          def process_client_with_rack_after_reply(client)
            # We can't install the AppProxy in #initialize, because
            # the HttpServer is already instantiated by the time we
            # typically run. Wrap it here exactly once.
            self.app = AppProxy.new(self, app) unless @rack_after_reply_wrapped
            @rack_after_reply_wrapped = true

            process_client_without_rack_after_reply(client)
            fire_rack_after_reply
          end
          RackAfterReply.freedom_patch(self, :process_client)
        end
      end
    end
  end
end
