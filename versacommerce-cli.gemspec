lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versacommerce/cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'versacommerce-cli'
  spec.version       = Versacommerce::CLI::VERSION
  spec.authors       = ['Tobias Bühlmann']
  spec.email         = ['buehlmann@versacommerce.de']

  spec.summary       = 'CLI tool for interacting with several VersaCommerce services.'
  spec.description   = 'Versacommerce::CLI is a Command Line Interface tool that interacts with several VersaCommerce-related services.'
  spec.homepage      = 'https://github.com/versacommerce/versacommerce-cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'thor', '0.19.1'
  spec.add_runtime_dependency 'listen', '~> 2.9'
  spec.add_runtime_dependency 'colorize', '0.7.5'
  spec.add_runtime_dependency 'versacommerce-theme_api_client', '0.1.1'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'pry', '0.10.1'
  spec.add_development_dependency 'pry-stack_explorer', '0.4.9.2'
end
