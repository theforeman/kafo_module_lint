require 'kafo_parsers/parsers'
require 'kafo/data_type'
require 'kafo/exceptions'

module KafoModuleLint
  class Linter
    attr_reader :path

    def initialize(path)
      @path = path
    end

    def pass?
      errors.empty?
    end

    def errors
      @errors ||= begin
        errors = []
        parsed[:types].each do |param,type|
          check_param(param, type, errors)
        end
        errors
      end
    end

    def puts_errors
      errors.each { |e| puts e }
    end

    private

    def self.parser
      @parser ||= KafoParsers::Parsers.find_available
    end

    def parsed
      @parsed ||= self.class.parser.parse(path)
    end

    def check_param(param, type, errors)
      return true if type == 'password'  # special case
      begin
        Kafo::DataType.new_from_string(type)
        true
      rescue Kafo::ConfigurationException => e
        errors << "#{path} parameter #{param}: #{e.message}"
        false
      end
    end
  end
end
