# -*- coding:UTF-8 -*-
$:.unshift(File.expand_path(File.dirname(__FILE__))) unless
    $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "iut/version"
require "iut/template_version"
require "iut/generator"
require "iut/arc"

Version = "#{Iut::VERSION} (template #{Iut::TEMPLATE_VERSION})"

opt = OptionParser.new
opt.on('-p', '--project PROJECT', 'Set project path PROJECT.') {|v| v }

opt.banner = <<EOF
Usage: iut [command] [subcommand] [options] [TEST_PROJECT_NAME]

Commands are:
              Nothing command, makes a empty project of iUnitTest.
              The project name is specified by TEST_PROJECT_NAME.
  arc         Set a compile flag to use ARC. And scanned all files.
              If a class doesn't use ARC, set a compile flag
              -fno-objc-arc to the class.
  arc revert  Revert a previous arc command

ex)
 $ iut TestProject    It makes iUnitTest's empty project TestProject.
 $ iut arc            Set a compile flag to use ARC.
 $ iut arc revert     Revert a previous arc command.

EOF

#opt.on('-h', '--help', 'show this help message and exit') {|v| }
argv = opt.parse(ARGV)

if argv.size == 0
  argv.unshift "--help"
  argv = opt.parse(argv)
end

case argv[0]
when /arc/
  Iut::Arc.parse
else
  Iut::Generator::Project.generate
end
