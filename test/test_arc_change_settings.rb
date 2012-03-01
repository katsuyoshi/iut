require "test-unit"
require "kagemusha"

iut_path = File.join(File.expand_path(File.dirname(__FILE__)), "../", "lib", "iut")
$:.unshift(iut_path) unless
    $:.include?(iut_path) || $:.include?(File.expand_path(iut_path))

require "arc"

class TestArc < Test::Unit::TestCase

  def setup
    project_path = File.join(File.expand_path(File.dirname(__FILE__)), "files", "IUTTest")
    @arc = Iut::Arc.new
    @arc.project_path = project_path
#p project_path
  end
  
  def teardown
    Dir.chdir @arc.project_path do
      FileUtils.cp "IUTTest.xcodeproj/project.pbxproj.org", "IUTTest.xcodeproj/project.pbxproj"
    end
  end
  
  def test_project_file
    @arc.change_project_settings
    Dir.chdir @arc.project_path do
      actual = File.read("IUTTest.xcodeproj/project.pbxproj").split("\n")
      expected = File.read("IUTTest.xcodeproj/project.pbxproj.expected").split("\n")
      expected.each_with_index do |l, i|
        assert_equal expected[i], actual[i]
      end
#      assert_equal File.read("IUTTest.xcodeproj/project.pbxproj.expected"), File.read("IUTTest.xcodeproj/project.pbxproj")
    end
  end
  
end

