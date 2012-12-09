# -*- encoding: utf-8 -*-
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
#require 'fakessl/version'
require File.expand_path('../lib/fakessl/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "fakessl"
  gem.version       = Fakessl::VERSION
  gem.authors       = ["Matteo Michelini"]
  gem.email         = ["cor3ngine@gmail.com"]
  gem.description   = %q{FakeSSL impersonates an HTTPS server and displays the client requests}
  gem.summary       = %q{FakeSSL impersonates an HTTPS server and displays the client requests}
  gem.homepage      = "https://github.com/cor3ngine/fakessl"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
