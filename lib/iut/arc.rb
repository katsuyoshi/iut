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
            a = context.scan(/@interface.*:\s([^\s]+)/)
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
    
  end

end
