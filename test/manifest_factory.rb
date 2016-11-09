class ManifestFactory
  def self.build(parameters = {})
    manifest = StringIO.new
    manifest << <<EOS
# This manifest is used for testing
#
# === Parameters
#
EOS
    parameters.each do |param, type|
      manifest.puts "# $#{param}::  a parameter for #{param}"
      manifest.puts "#  #{' ' * param.length}    type:#{type}" if type
    end

    manifest.puts "class testing#{counter}("
    parameters.keys.each do |param|
      manifest.puts "  $#{param},"
    end
    manifest.puts ') { }'
    manifest.string
  end

  def self.counter
    @counter = 0 if @counter.nil?
    @counter += 1
  end
end
