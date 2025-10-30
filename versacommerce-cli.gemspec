lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versacommerce/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'versacommerce-cli'
  spec.version       = Versacommerce::CLI::VERSION
  spec.authors       = ['VersaCommerce GmbH']
  spec.summary       = 'CLI tool for interacting with several VersaCommerce services.'
  spec.description   = 'Versacommerce::CLI is a Command Line Interface tool that interacts with several VersaCommerce-related services.'
  spec.homepage      = 'https://github.com/versacommerce/versacommerce-cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1.0'

  spec.add_runtime_dependency 'thor', '~> 1.3'
  spec.add_runtime_dependency 'listen', '~> 3.9'
  spec.add_runtime_dependency 'colorize', '~> 1.1'
  spec.add_runtime_dependency 'versacommerce-theme_api_client', '~> 1.0.3'

  spec.add_development_dependency 'bundler', '>= 1.8'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'pry', '~> 0.14'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.6'
end
