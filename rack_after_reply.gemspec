$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'rack_after_reply/version'

Gem::Specification.new do |s|
  s.name        = 'rack_after_reply'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.version     = RackAfterReply::VERSION.join('.')
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["George Ogata"]
  s.email       = ["george.ogata@gmail.com"]
  s.homepage    = "http://github.com/oggy/rack_after_reply"
  s.summary     = "Rack hook which fires after the socket to the client is closed."

  s.required_rubygems_version = ">= 1.3.6"
  s.files = Dir["{doc,lib,rails}/**/*"] + %w(LICENSE README.markdown Rakefile CHANGELOG)
  s.test_files = Dir["spec/**/*"]
  s.extra_rdoc_files = ["LICENSE", "README.markdown"]
  s.require_path = 'lib'
  s.specification_version = 3
  s.rdoc_options = ["--charset=UTF-8"]
end
