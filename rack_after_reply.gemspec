$:.unshift File.expand_path('lib', File.dirname(__FILE__))
require 'rack_after_reply/version'

Gem::Specification.new do |gem|
  gem.name        = 'rack_after_reply'
  gem.date        = Time.now.strftime('%Y-%m-%d')
  gem.version     = RackAfterReply::VERSION.join('.')
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ["George Ogata"]
  gem.email       = ["george.ogata@gmail.com"]
  gem.license     = 'MIT'
  gem.homepage    = "http://github.com/oggy/rack_after_reply"
  gem.summary     = "Rack hook which fires after the socket to the client is closed."

  gem.required_rubygems_version = ">= 1.3.6"
  gem.files = Dir["{doc,lib,rails}/**/*"] + %w(LICENSE README.markdown Rakefile CHANGELOG)
  gem.test_files = Dir["spec/**/*"]
  gem.extra_rdoc_files = ["LICENSE", "README.markdown"]
  gem.require_path = 'lib'
  gem.specification_version = 3
  gem.rdoc_options = ["--charset=UTF-8"]
end
