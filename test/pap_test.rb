# frozen_string_literal: true

require "test_helper"

class PapTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Pap.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    assert_equal("expected", "actual")
  end
end
