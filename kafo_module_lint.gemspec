# encoding: utf-8
require File.join(File.expand_path(File.dirname(__FILE__)), 'lib', 'kafo_module_lint', 'version')

Gem::Specification.new do |spec|
  spec.name          = "kafo_module_lint"
  spec.version       = KafoModuleLint::VERSION
  spec.authors       = ["Dominic Cleal"]
  spec.email         = ["dominic@cleal.org"]
  spec.summary       = %q{Validate Puppet modules are correctly documented for Kafo}
  spec.description   = %q{Validates Puppet modules and manifests to ensure parameters are all correctly documented for use with the Kafo gem}
  spec.homepage      = "https://github.com/domcleal/kafo_module_lint"
  spec.license       = "GPLv3+"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency 'kafo', '>= 1.0.4', '< 3'
  spec.add_dependency 'kafo_parsers'
  spec.add_dependency 'puppet-strings', '>= 0.99', '< 3'
end
