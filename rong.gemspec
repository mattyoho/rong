version = '0.2.0'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'rong'
  s.version     = version
  s.summary     = 'Ruby-based client-server Pong implementation'
  s.description = 'Rong is a Ruby implementation of Pong that consists of a server module for managing games, a client module for for interfacing with the server, and hopefully a few client implementations for playing some rad Pong, brah.'

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.author            = 'Matt Yoho'
  s.email             = 'mby@mattyoho.com'
  s.homepage          = 'http://github.com/mattyoho/rong'

  s.add_dependency('rong-server',   version)
  s.add_dependency('rong-elements', version)

  s.add_development_dependency('rspec', '~> 2.0.0.beta.19')
end
