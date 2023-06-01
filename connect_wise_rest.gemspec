# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'connect_wise_rest/version'

Gem::Specification.new do |spec|
  spec.name          = 'connect_wise_rest'
  spec.version       = ConnectWiseRest::VERSION
  spec.authors       = ['Kevin Pheasey']
  spec.email         = ['kevin@kpsoftware.io']

  spec.summary       = %q{REST client wrapper for Connect Wise.}
  spec.description   = %q{A dead simple REST client wrapper for Connect Wise.}
  spec.homepage      = 'https://github.com/MSPCFO/connect_wise_rest'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_dependency 'httparty', '~> 0.13'
end
