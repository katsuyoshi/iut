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
Usage:
  Makes a iUnitTest's empty project named TEST_PROJECT_NAME.

    iut TEST_PROJECT_NAME
  
  Set the compile option Automatic Refarence counting to YES.
  And scanned all files.
  If a class doesn't use ARC, set a compile flag -fno-objc-arc to the class.

    iut arc [subcommand] [options] 

  subcommands are:
              Nothing subcommand, set compile flags of ARC.
              It makes backup file.
    revert    Revert a project from previous arc command's backup.
    clean     Remove all backup files.

  options are:
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
