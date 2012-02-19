#!/usr/bin/env ruby
# -*- coding:UTF-8 -*-
require "fileutils"
require "git"

path = File.expand_path(File.dirname __FILE__)

dst_path = File.join(path, "../tmp")

FileUtils.mkdir_p dst_path

Dir.chdir(dst_path) do

  # clone source
  unless File.exist? "iunittest"
    system "git clone git@github.com:katsuyoshi/iunittest.git"
  else
    Dir.chdir("iunittest") do
      system "git pull"
    end
  end

  # copty to template
  src_path = "iunittest/iUnitTest/iUnitTest/iunittest"
  dst_path = "../template/project/iUnitTest/iUnitTest"
  FileUtils.cp_r src_path, dst_path
  Dir.chdir "../template/project" do
    [
      "iUnitTest/iUnitTest/iunittest/IUTMainWindow.xib"
    ].each do |f|
      system "git checkout #{f}"
    end
  end

  # copy script
  src_path = "iunittest/iUnitTest/script"
  dst_path = "../template/project/iUnitTest"
  FileUtils.cp_r src_path, dst_path
  
  # write hash
  g = Git.open("iunittest")
  sha = g.log.first.sha[0, 7]
  File.open("../lib/iut/template_version.rb", "w") do |f|
    f.write <<EOF
# -*- encoding:UTF-8 -*-
module Iut
  TEMPLATE_VERSION = "#{sha}"
end
EOF
  end
end
