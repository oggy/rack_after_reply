module RackAfterReply
  module Adapter
    class Thin < Base
      def apply
        ::Thin::Connection.module_eval do
          def pre_process_with_rack_after_reply
            callbacks = []
            @request.env[RackAfterReply::CALLBACKS_KEY] = callbacks
            EM.next_tick { callbacks.each {|c| c.call} }
            pre_process_without_rack_after_reply
          end
          RackAfterReply.freedom_patch self, :pre_process
        end
      end
    end
  end
end
