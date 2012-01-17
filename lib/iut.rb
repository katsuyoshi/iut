# -*- encoding:UTF-8 -*-
$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "iut/version"
require "iut/generator"

Version = Iut::VERSION

opt = OptionParser.new
opt.banner = "Usage: #{$0} TEST_PROJECT_NAME"
#opt.on('-h', '--help', 'show this help message and exit') {|v| }
opt.parse!(ARGV)

if ARGV.size == 0
  ARGV.unshift "--help"
  opt.parse!(ARGV)
end

Iut::Generator::Project.generate
