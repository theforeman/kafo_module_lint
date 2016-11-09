require 'kafo_module_lint'

module KafoModuleLint
  class RakeTask < ::Rake::TaskLib
    include ::Rake::DSL if defined?(::Rake::DSL)

    DEFAULT_PATTERN = 'manifests/**/*.pp'

    attr_accessor :name
    attr_accessor :pattern
    attr_accessor :modulepath

    def initialize(*args, &task_block)
      @name = args.shift || :'lint:kafo_module'
      @pattern = DEFAULT_PATTERN
      @modulepath = File.join('spec', 'fixtures', 'modules')
      define(args, &task_block)
    end

    def define(args, &task_block)
      desc 'Lint Puppet module with KafoModuleLint'

      task_block.call(*[self, args].slice(0, task_block.arity)) if task_block

      Rake::Task[name].clear if Rake::Task.task_defined?(name)

      definition = Rake::Task.task_defined?('spec_prep') ? {name => [:'spec_prep']} : name
      task definition do
        RakeFileUtils.send(:verbose, true) do
          result = true
          TypeLoader.new(modulepath).with_types do
            FileList[pattern].each do |manifest|
              linter = Linter.new(manifest)
              result = false unless linter.pass?
              linter.puts_errors
            end
          end

          abort unless result
        end
      end

      Rake::Task[:lint].enhance [name] if Rake::Task.task_defined?('lint')
    end
  end
end

KafoModuleLint::RakeTask.new
