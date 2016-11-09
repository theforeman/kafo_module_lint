require 'kafo/kafo_configure'
require 'kafo/data_type_parser'

module KafoModuleLint
  class TypeLoader
    attr_reader :modulepath

    def initialize(modulepath)
      @modulepath = modulepath

      # Workaround as DataTypeParser assumes KafoConfigure is in use
      Kafo::KafoConfigure.logger ||= Logger.new(STDERR)
    end

    def with_types(&block)
      parsers = Dir[type_pattern].map { |manifest| Kafo::DataTypeParser.new(File.read(manifest)) }
      parsers.each(&:register)
      yield
    ensure
      parsers.each do |parser|
        parser.types.keys.each { |type| Kafo::DataType.unregister_type(type) }
      end if parsers
    end

    private

    def type_pattern
      File.join(modulepath, '*', 'types', '**' , '*.pp')
    end
  end
end
