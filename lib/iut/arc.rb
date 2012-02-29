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
      Dir.chdir self.project_path do
        Dir.glob("**/#{class_name}\.[hm]") do |f|
          context = File.read f
          # remove comment
          context.gsub! /\/\/.*\n/, ""
          context.gsub! /\/\*.*\*\//m, ""
          # remove space
          context.gsub! /\s+/, " "

          case f[-1, 1]
          when "h"
            case context
            when /@property\s*\(.*copy(\s*|\]|\))/,
                 /@property\s*\(.*retain(\s*|\]|\))/
              return true
            else
              false
            end
          when "m"
            case context
            when /\s+dealloc(\s*|\])/, /\s+autorelease(\s*|\])/,
                 /\s+dealloc(\s*|\])/, /\s+release(\s*|\])/
              return true
            else
              false
            end
          else
            false
          end
        end
      end
      false
    end
    
    def arc? class_name
      !self.nonarc? class_name
    end
    
  end

end
