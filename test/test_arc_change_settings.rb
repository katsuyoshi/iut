require "test-unit"
require "kagemusha"

iut_path = File.join(File.expand_path(File.dirname(__FILE__)), "../", "lib", "iut")
$:.unshift(iut_path) unless
    $:.include?(iut_path) || $:.include?(File.expand_path(iut_path))

require "arc"


class TestArcChangeSettings < Test::Unit::TestCase

  def setup
    project_path = File.join(File.expand_path(File.dirname(__FILE__)), "files", "IUTTest")
    @arc = Iut::Arc.new
    @arc.project_path = project_path
  end
  
  def teardown
    Dir.chdir @arc.project_path do
      FileUtils.cp "IUTTest.xcodeproj/project.pbxproj.org", "IUTTest.xcodeproj/project.pbxproj"
      Dir.glob("IUTTest.xcodeproj/project.pbxproj.2*") do |f|
        FileUtils.rm f
      end
    end
  end
  
  def test_change_project_settings
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
  
  def test_change_project_settings_twice
    @arc.change_project_settings
    @arc.change_project_settings
    Dir.chdir @arc.project_path do
      assert_equal File.read("IUTTest.xcodeproj/project.pbxproj.expected"), File.read("IUTTest.xcodeproj/project.pbxproj")
    end
  end
  
  def test_arc_parse_change_project_settings
    ARGV.replace ['arc', '-p', @arc.project_path]
    Iut::Arc.parse
    Dir.chdir @arc.project_path do
      assert_equal File.read("IUTTest.xcodeproj/project.pbxproj.expected"), File.read("IUTTest.xcodeproj/project.pbxproj")
    end
  end
  
  def test_arc_make_backup
    @arc.change_project_settings
    Dir.chdir @arc.project_path do
      files = Dir.glob("**/project.pbxproj.2*")
      assert_equal 1, files.size
    end
  end
  
  def test_revert
    @arc.change_project_settings
    @arc.revert
    Dir.chdir @arc.project_path do
      assert_equal File.read("IUTTest.xcodeproj/project.pbxproj.org"), File.read("IUTTest.xcodeproj/project.pbxproj")
    end
  end
  
  def test_arc_parse_revert
    @arc.change_project_settings
    ARGV.replace ['arc', 'revert', '-p', @arc.project_path]
    Iut::Arc.parse
    Dir.chdir @arc.project_path do
      assert_equal File.read("IUTTest.xcodeproj/project.pbxproj.org"), File.read("IUTTest.xcodeproj/project.pbxproj")
    end
  end
  
  
end

