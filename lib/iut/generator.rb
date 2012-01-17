# -*- encoding:UTF-8 -*-
require "fileutils"
require "optparse"

module Iut

  module Generator
  
    TEMPLATE_PATH = File.join(File.expand_path(File.dirname(__FILE__)), "../../template")
    
    module Project
    
      def self.generate
        project_name = ARGV[0]
        src = File.join(TEMPLATE_PATH, "project", "iUnitTest")
        dst = File.join(File.expand_path("./"), ARGV[0])
        if File.exists?(dst)
          puts "#{project_name}: File exists"
          exit
        end
        FileUtils.cp_r src, dst
        
        Dir.chdir dst do
        
          # rename files
          replace_file_patterns = {
            "TEST_PROJECT.xcodeproj" => "#{project_name}.xcodeproj",
            "iUnitTest/TEST_PROJECT-info.plist" => "iUnitTest/#{project_name}-info.plist",
            "iUnitTest/TEST_PROJECT-Prefix.pch" => "iUnitTest/#{project_name}-Prefix.pch"
          }
          replace_file_patterns.each do |k, v|
            FileUtils.mv k, v
          end
          
          # replace project setting
          project_file_name = "#{project_name}.xcodeproj/project.pbxproj"
          project = File.read project_file_name
          project.gsub!("TEST_PROJECT", project_name);
          File.open(project_file_name, "w") do |f|
            f.write project
          end
          
          # remove user file
          [
            "#{project_name}.xcodeproj/xcuserdata",
            "#{project_name}.xcodeproj/project.xcworkspace"
          ].each do |f|
            FileUtils.rm_r f if File.exists? f
          end
                    
        end
      end
      
    end
      
  end
  
end

