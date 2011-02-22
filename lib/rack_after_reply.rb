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
