module RackAfterReply
  #
  # Wraps a Rack app to intercept the rack environment passed to #call
  # for access by the request handler after the socket is closed.
  #
  class AppProxy
    def initialize(request_handler, app)
      @request_handler = request_handler
      @app = app
    end

    def call(env)
      callbacks = []
      env[RackAfterReply::CALLBACKS_KEY] = callbacks
      @request_handler.rack_after_reply_callbacks = callbacks
      @app.call(env)
    end

    def method_missing(name, *args, &block)
      class_eval <<-EOS
        def #{name}(*args, &block)
          @app.#{name}(*args, &block)
        end
      EOS
      send(name, *args, &block)
    end

    def respond_to?(name, include_private=false)
      super || @app.respond_to?(name, include_private)
    end
  end
end
