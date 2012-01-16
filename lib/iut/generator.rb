# -*- encoding:UTF-8 -*-
require "fileutils"
require "optparse"

module Iut

  module Generator
  
    TEMPLATE_PATH = File.expand_path(File.join(File.basename(__FILE__), "../../template"))
    
    module Project
    
      def self.generate
        src = File.join(TEMPLATE_PATH, "project", "iUnitTest")
        dst = File.expand_path(File.join("./", ARGV[0]))
        if File.exists?(dst)
          puts "#{ARGV[0]}: File exists"
          exit
        end
        FileUtils.cp_r src, dst
      end
      
    end
      
  end
  
end

