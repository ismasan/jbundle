# -*- encoding: utf-8 -*-
require File.expand_path("../lib/jbundle/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "jbundle"
  s.version     = JBundle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Ismael Celis']
  s.email       = ['ismaelct@gmail.com']
  s.homepage    = "http://github.com/ismasan/jbundle"
  s.description     = "Writes versioned, bundled and minified javascript files and dependencies"
  s.summary = "Good for releasing javascript libraries composed of many files. Writes files apt for deploying to CDNs."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "jbundle"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", '1.3.1'
  s.add_dependency 'closure-compiler'
  s.add_dependency 'thor'
  s.add_dependency 'rack'

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
