require 'test_helper'
require 'kafo_module_lint/linter'
require 'pathname'

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
      let(:error) { "#{manifest_file} parameter b: unknown data type Unknown" }
      specify { linter.pass?.must_equal false }
      specify { linter.errors.must_equal [error] }
      specify { proc { linter.puts_errors }.must_output (error + $/) }
    end

    describe "with relative path" do
      let(:manifest) { ManifestFactory.build({}) }
      let(:manifest_file) do
        Pathname.new(ManifestFileFactory.build(manifest).path).relative_path_from(Pathname.new(Dir.pwd)).to_s
      end
      specify { linter.pass?.must_equal true }
    end

    describe "with future parser" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Unknown[String]'}) }
      before { ENV['FUTURE_PARSER'] = 'yes' }
      after { ENV.delete('FUTURE_PARSER') }

      specify { linter.pass?.must_equal true }
      specify { linter.errors.must_equal [] }
      specify { proc { linter.puts_errors }.must_output nil }
    end

    describe "with wrong argument count" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Undef["foo"]'}) }
      let(:error) { "#{manifest_file} parameter b: wrong number of arguments (given 1, expected 0)" }
      specify { linter.pass?.must_equal false }
      specify { linter.errors.must_equal [error] }
      specify { proc { linter.puts_errors }.must_output (error + $/) }
    end
  end
end
