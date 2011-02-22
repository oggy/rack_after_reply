# Rack After Reply

A hook for Rack apps which fires after the response has been sent, and
the socket to the client has been closed.

This is the ideal time to perform delayable, non-backgroundable tasks,
such as garbage collection, stats gathering, flushing logs, etc.
without affecting response times at all.

## Usage

Simply add your callbacks to `env['rack_after_reply.callbacks']`.

    use Rack::ContentLength
    use Rack::ContentType, 'text/plain'
    run lambda { |env|
      env['rack_after_reply.callbacks'] << lambda { ... }
      [200, {}, ['hi']]
    }

## Support

Rack After Request works with these web servers:

 * [Mongrel](https://github.com/fauna/mongrel)
 * [Passenger](http://www.modrails.com)
 * [Thin](https://github.com/macournoyer/thin)
 * [Unicorn](http://unicorn.bogomips.org)
 * WEBrick (distributed with Ruby)

To request support for other web servers, [open a ticket][issues] or
submit a patch.

[issues]: http://github.com/oggy/rack_after_reply/issues

## Contributing

 * [Bug reports](https://github.com/oggy/rack_after_reply/issues)
 * [Source](https://github.com/oggy/rack_after_reply)
 * Patches: Fork on Github, send pull request.
   * Ensure patch includes tests.
   * Leave the version alone, or bump it in a separate commit.

## Copyright

Copyright (c) George Ogata. See LICENSE for details.
