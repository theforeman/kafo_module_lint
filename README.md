# Kafo Module Lint

This gem provides a linter to validate a Puppet module is correctly documented
for use with [Kafo](https://github.com/theforeman/kafo), a library that
generates an "installer" from modules.

## Installation

Add this line to your module's Gemfile:

    gem 'kafo_module_lint', '~> 1.0'

It's highly recommended to also include the [puppet-lint-param-docs](https://github.com/domcleal/puppet-lint-param-docs)
lint plugin to ensure _all_ parameters are documented:

    gem 'puppet-lint-param-docs'

## Usage

Add this line to your module's Rakefile:

    require 'kafo_module_lint/tasks'

This will automatically register a new `lint:kafo_module` task and enhance the
`lint` task if it exists (i.e. from puppet-lint).

puppet-lint should also be enabled by following [its Usage instructions](https://github.com/rodjek/puppet-lint#rake)
to run the puppet-lint-param-docs plugin.

With both enabled, running `rake lint` will check the module for correctness.

Alternatively, run `kafo-module-lint` to check all manifests or pass individual
paths to check one or more files.

### Rake task config options

Customise the rake task with a configuration block:

    KafoModuleLint::RakeTask.new do |lint|
      lint.pattern = ['manifests/init.pp']
    end

It supports:

* `lint.modulepath` - module path to load custom types from, defaults to
  `spec/fixtures/modules`
* `lint.pattern` - files to lint check, defaults to `manifests/**/*.pp`

# License

Copyright (c) 2016 Dominic Cleal

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
