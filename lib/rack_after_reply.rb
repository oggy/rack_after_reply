require 'rack'

module RackAfterReply
  CALLBACKS_KEY = 'rack_after_reply.callbacks'.freeze

  autoload :AppProxy, 'rack_after_reply/app_proxy'
  autoload :Adapter, 'rack_after_reply/adapter'
  autoload :RequestHandler, 'rack_after_reply/request_handler'

  class << self
    #
    # Apply extensions for all loaded web servers.
    #
    def apply
      Adapter::Thin.apply if defined?(::Thin)
      Adapter::Mongrel.apply if defined?(::Mongrel)
      Adapter::Passenger.apply if defined?(::PhusionPassenger)
      Adapter::WEBrick.apply if defined?(::WEBrick)
      Adapter::Unicorn.apply if defined?(::Unicorn)
    end

    def freedom_patch(mod, method) # :nodoc:
      # Prevent infinite recursion if we've already done it.
      return if mod.method_defined?("#{method}_without_rack_after_reply")

      mod.module_eval do
        alias_method "#{method}_without_rack_after_reply", method
        alias_method method, "#{method}_with_rack_after_reply"
      end
    end

    def freedom_extend(object, method) # :nodoc:
      klass = (class << object; self; end)
      freedom_patch(klass, method)
    end
  end
end

RackAfterReply.apply

# The web server library may not be loaded until we've instantiated the Rack
# handler (e.g., Rails 3.0's console command when no server argument is given),
# so call apply once we know that has happened too.
Rack::Server.class_eval do
  def server_with_rack_after_reply
    result = server_without_rack_after_reply
    RackAfterReply.apply
    result
  end

  RackAfterReply.freedom_patch(self, :server)
end
