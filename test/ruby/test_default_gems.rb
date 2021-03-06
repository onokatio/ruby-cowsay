# frozen_string_literal: false
require 'rubygems'

class TestDefaultGems < Test::Unit::TestCase

  def test_validate_gemspec
    omit "git not found" unless system("git", "rev-parse", %i[out err]=>IO::NULL)
    srcdir = File.expand_path('../../..', __FILE__)
    Dir.glob("#{srcdir}/{lib,ext}/**/*.gemspec").map do |src|
      assert_nothing_raised do
        raise("invalid spec in #{src}") unless Gem::Specification.load(src)
      end
    end
  end

end
