# -*- coding:UTF-8 -*-
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

    @pwd = File.expand_path(Dir.pwd)
    Dir.chdir @arc.project_path
  end
  
  def teardown
    Dir.chdir @pwd
  end
  
  
  def test_non_arc_case_dealloc_should_not_be_arc
    assert(@arc.nonarc?("NonArcCaseDealloc"))
  end

  def test_non_arc_case_property_copy_should_not_be_arc
    assert(@arc.nonarc?("NonArcWithPropertyCopy"))
  end

  def test_non_arc_case_property_retain_should_not_be_arc
    assert(@arc.nonarc?("NonArcWithPropertyRetain"))
  end

  def test_non_arc_with_autorelease_in_methods_should_not_be_arc
    assert(@arc.nonarc?("NonArcWithAutoreleaseInMethod"))
  end

  def test_non_arc_with_release_in_methods_should_not_be_arc
    assert(@arc.nonarc?("NonArcWithReleaseInMethod"))
  end

  def test_arc_should_be_arc
    assert(@arc.arc?("Arc"))
  end

  def test_arc_with_retain_in_comment_should_be_arc
    assert(@arc.arc?("ArcWithRetainInComment"))
  end

  def test_arc_should_not_be_arc
    assert(@arc.nonarc?("LooksArcButSuperDoesNotUse"))
  end

end


