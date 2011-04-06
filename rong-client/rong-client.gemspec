version = '0.2.0'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'rong-client'
  s.version     = version
  s.summary     = 'Client library for a Ruby-based Pong server implementation'
  s.description = 'Rong-client is the catch-all Rong client package, and in the future will hopefully be replaced with platform-specifc implementations.'

  s.required_ruby_version     = '>= 1.9.2'
  s.required_rubygems_version = ">= 1.3.7"

  s.files = Dir['lib/**/*']

  s.author            = 'Matt Yoho'
  s.email             = 'mby@mattyoho.com'
  s.homepage          = 'http://github.com/mattyoho/rong'

  s.add_dependency('gosu', '~> 0.7.28')
  s.add_development_dependency('rspec', '~> 2.5.0')
  s.add_development_dependency('ruby-debug19')
end
