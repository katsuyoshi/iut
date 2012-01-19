# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "iut/version"

Gem::Specification.new do |s|
  s.name        = "iut"
  s.version     = Iut::VERSION
  s.authors     = ["Katsuyoshi Ito"]
  s.email       = ["kito@itosoft.com"]
  s.homepage    = "https://github.com/katsuyoshi/iunittest"
  s.summary     = %q{It generates a iUnitTest test project for Xcode 4.x.}
  s.description = %q{After Xcode 4 released, the format of template project was changed. The aim of this command is to make a iUnitTest test project easily. }

  s.rubyforge_project = "iut"

  s.files         = `git ls-files`.split("\n").find_all{|f| !(/^script/ =~ f)}
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
