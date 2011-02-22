module RackAfterReply
  module RequestHandler
    attr_accessor :rack_after_reply_callbacks

    def fire_rack_after_reply
      # Ensure we only fire the hook once. Passenger runs its request
      # handler when shutting down, causing an infinite loop if we
      # don't check for this.
      rack_after_reply_callbacks or
        return

      rack_after_reply_callbacks.each do |callback|
        callback.call
      end
      self.rack_after_reply_callbacks = nil
    end
  end
end
