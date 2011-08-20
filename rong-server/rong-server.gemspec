version = '0.2.2'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'rong-server'
  s.version     = version
  s.summary     = 'Ruby-based Pong server implementation'
  s.description = 'Rong-server is the server component for Rong, a Ruby implementation of Pong that consists of a server module for managing games, a client module for for interfacing with the server, and hopefully a few client implementations for playing some rad Pong, brah.'

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.7"

  s.files = Dir['lib/**/*']

  s.author            = 'Matt Yoho'
  s.email             = 'mby@mattyoho.com'
  s.homepage          = 'http://github.com/mattyoho/rong'

  s.add_runtime_dependency('rong-elements', '~> 0.2.2')

  s.add_development_dependency('rspec', '~> 2.6.0')
  s.add_development_dependency('guard', '~> 0.6.1')
  s.add_development_dependency('guard-rspec', '~> 0.4.2')
  s.add_development_dependency('rb-fsevent', '~> 0.4.3')
  s.add_development_dependency('growl', '~> 1.0.3')
  s.add_development_dependency('growl_notify', '~> 0.0.1')
  s.add_development_dependency('ruby-debug19')
end
