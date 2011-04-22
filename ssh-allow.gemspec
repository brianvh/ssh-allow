# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ssh/allow/version"

Gem::Specification.new do |s|
  s.name        = "ssh-allow"
  s.version     = SSH::Allow::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian V. Hughes"]
  s.email       = ["brianvh@dartmouth.edu"]
  s.homepage    = %(https://github.com/brianvh/ssh-allow/)
  s.summary     = %(#{s.name}-#{s.version})
  s.description = %(Command-line binary and mini-DSL for configuring the commands an 
SSH key-authenticated remote SSH connection is allowed to run.)

  s.rubyforge_project = "ssh-allow"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'thor', '~> 0.14.6'
  s.add_dependency 'polyglot', '~> 0.3.1'
  s.add_dependency 'treetop', '~> 1.4.9'

  s.add_development_dependency 'bundler', '~> 1.0.10'
  s.add_development_dependency 'rspec', '~> 2.5.0'
  s.add_development_dependency 'aruba', '~> 0.3.5'
end
