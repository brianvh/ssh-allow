# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "remote_key/version"

Gem::Specification.new do |s|
  s.name        = "remote_key"
  s.version     = RemoteKey::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian V. Hughes"]
  s.email       = ["brianvh@dartmouth.edu"]
  s.homepage    = ""
  s.summary     = %(#{s.name}-#{s.version})
  s.description = %(Process a YAML file that configures allowed commands an 
SSH key-authenticated remote SSH connection can run.)

  s.rubyforge_project = "remote_key"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'thor', '~> 0.14.6'

  s.add_development_dependency 'bundler', '~> 1.0.10'
  s.add_development_dependency 'rspec', '~> 2.3.0'
  s.add_development_dependency 'aruba', '~> 0.3.2'
end
