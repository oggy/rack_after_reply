module RackAfterReply
  module Adapter
    class Base
      def self.apply
        return if defined?(@applied)
        instance.apply
        @applied = true
      end

      def self.instance
        @instance ||= new
      end
    end
  end
end
