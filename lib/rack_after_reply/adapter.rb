module RackAfterReply
  module Adapter
    autoload :Base, 'rack_after_reply/adapter/base'
    autoload :Mongrel, 'rack_after_reply/adapter/mongrel'
    autoload :Passenger, 'rack_after_reply/adapter/passenger'
    autoload :Thin, 'rack_after_reply/adapter/thin'
    autoload :Unicorn, 'rack_after_reply/adapter/unicorn'
    autoload :WEBrick, 'rack_after_reply/adapter/webrick'
  end
end
