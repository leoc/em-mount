# -*- encoding: utf-8 -*-
require File.expand_path('../lib/em-mount/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Arthur Andersen"]
  gem.email         = ["leoc.git@gmail.com"]
  gem.description   = %q{Eventmachine interface of the linux mount command}
  gem.summary       = %q{Eventmachine interface of the linux mount command}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "em-mount"
  gem.require_paths = ["lib"]
  gem.version       = EventMachine::Mount::VERSION

  gem.add_dependency 'em-systemcommand'
end
