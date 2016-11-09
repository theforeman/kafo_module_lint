require 'test_helper'

module KafoModuleLint
  describe 'kafo-module-lint' do
    let(:manifest_file) { ManifestFileFactory.build(manifest).path }
    let(:args) { manifest_file }
    let(:captured) do
      ret = capture_subprocess_io { system("bundle exec bin/kafo-module-lint #{args}") }
      [$?, *ret]
    end
    let(:exit_code) { captured[0] }
    let(:stdout) { captured[1] }
    let(:stderr) { captured[2] }

    describe "manifest with no params" do
      let(:manifest) { ManifestFactory.build({}) }
      specify { exit_code.success?.must_equal true }
      specify { stdout.must_equal '' }
      specify { stderr.must_equal '' }
    end

    describe "manifest with built-in params" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Optional[Array[Integer[0]]]'}) }
      specify { exit_code.success?.must_equal true }
      specify { stdout.must_equal '' }
      specify { stderr.must_equal '' }
    end

    describe "manifest with unknown param" do
      let(:manifest) { ManifestFactory.build({'a' => 'String', 'b' => 'Unknown[String]'}) }
      let(:error) { "#{manifest_file} parameter b: unknown data type Unknown" }
      specify { exit_code.success?.must_equal false }
      specify { stdout.must_equal (error + $/) }
      specify { stderr.must_equal '' }
    end
  end
end
