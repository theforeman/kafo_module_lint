source 'https://rubygems.org'

gemspec

puppet_version = ENV['PUPPET_VERSION']
puppet_spec = puppet_version ? "~> #{puppet_version}" : '< 7.0.0'
gem 'puppet', puppet_spec
