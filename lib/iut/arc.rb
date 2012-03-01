# -*- coding:UTF-8 -*-
require "fileutils"
require "optparse"

module Iut

  class Arc
  
    attr_accessor :project_path

    def initialize
      @project_path = Dir.pwd
    end
    
    def nonarc? class_name
      return false if class_name == "NSObject"
      
      super_name = "NSObject"
      
      Dir.chdir self.project_path do
        Dir.glob("**/#{class_name}\.[hm]") do |f|
          context = File.read f
          # remove comments
          context.gsub! /\/\/.*\n/, ""
          context.gsub! /\/\*.*\*\//m, ""
          # remove spaces
          context.gsub! /\s+/, " "

          case f[-2, 2]
          when /.h/i
            # get a name of super class
            a = context.scan(/@interface.*:\s(\S+)/)
            super_name = a.first.first if a.first
            
            case context
            when /@property\s*\(.*copy(\s*|\]|\))/,
                 /@property\s*\(.*retain(\s*|\]|\))/
              return true
            end
          when /.m/i
            case context
            when /\s+dealloc(\s*|\])/, /\s+autorelease(\s*|\])/,
                 /\s+dealloc(\s*|\])/, /\s+release(\s*|\])/
              return true
            end
          end
        end
      end
      nonarc? super_name
    end
    
    def arc? class_name
      !self.nonarc? class_name
    end
    
    def change_project_settings
      Dir.chdir self.project_path do
        Dir.glob("**/project.pbxproj") do |f|
          lines = []
          xcbuild_config_section = false
          context = File.read f
          seted_arc_project_setting = /CLANG_ENABLE_OBJC_ARC/ =~ context
          context.each_line do |l|
            case l
            when /Begin XCBuildConfiguration section/
              xcbuild_config_section = true
            when /End PBXBuildFile section/
              xcbuild_config_section = false
            when /ARCHS/
              unless seted_arc_project_setting
                l << "\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;\n" if xcbuild_config_section
              end
            when /(\S+)\.m.+in Sources.*isa = PBXBuildFile/i
              class_name = $1
              unless /settings/ =~ l
                if nonarc? class_name
                  l.gsub!("};\n", "settings = {COMPILER_FLAGS = \"-fno-objc-arc\"; }; };\n")
                end
              end
            end
            lines << l
          end
          File.open(f, "w") do |f|
            f.write lines.join
          end
        end
      end
    end
    
  end

end
