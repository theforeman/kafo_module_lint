require 'test_helper'
require 'kafo_module_lint/linter'

module KafoModuleLint
  describe Linter do
    let(:manifest_file) { ManifestFileFactory.build(manifest).path }
    let(:linter) { Linter.new(manifest_file) }

    describe "with no params" do
      let(:manifest) { ManifestFactory.build({}) }
      specify { linter.pass?.must_equal true }
      specify { linter.errors.must_equal [] }
      specify { proc { linter.puts_errors }.must_output nil }
    end

    describe "with built-in params" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Optional[Array[Integer[0]]]'}) }
      specify { linter.pass?.must_equal true }
      specify { linter.errors.must_equal [] }
      specify { proc { linter.puts_errors }.must_output nil }
    end

    describe "with unknown param" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Unknown[String]'}) }
      let(:error) { "#{manifest_file}: parameter b has an invalid type Unknown[String]: unknown data type Unknown" }
      specify { linter.pass?.must_equal false }
      specify { linter.errors.must_equal [error] }
      specify { proc { linter.puts_errors }.must_output (error + $/) }
    end
  end
end
