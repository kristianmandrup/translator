# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'translator/version'

Gem::Specification.new do |s|
  s.name        = 'translator'
  s.version     = Translator::Version::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = 'MIT'
  s.summary     = 'Flexible syncronization solution of locales with LocaleApp'
  s.email       = ['kd.engineer@yahoo.co.in']
  s.homepage    = 'https://github.com/kuldeepaggarwal/translator'
  s.description = 'Flexible syncronization solution of locales with LocaleApp'
  s.authors     = ['Kuldeep Aggarwal']

  s.rubyforge_project = 'devise'

  s.files         = `git ls-files`.split("\n")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency('localeapp', '~> 0.9.3')
  s.add_dependency('moneta', '~> 0.8.0')
  s.add_dependency('activesupport', '~> 3.2')
end
