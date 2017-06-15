# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'metrico/version'

Gem::Specification.new do |spec|
  spec.name          = 'metrico'
  spec.version       = Metrico::VERSION
  spec.authors       = ['Ivan Shamatov']
  spec.email         = ['status.enable@gmail.com']

  spec.summary       = 'NATS ruby client to write metrics'
  spec.description   = 'Use it to write your metrics in InfluxDB format through NATS'
  spec.homepage      = 'https://github.com/IvanShamatov/metrico'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'nats-pure'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
