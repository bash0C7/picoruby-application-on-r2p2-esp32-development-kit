require "test_helper"

class PicotorokkoMrbgemsDslTest < PraTestCase
  test "parse single github gem" do
    dsl_code = <<-RUBY
      mrbgems do |conf|
        conf.gem github: "ksbmyk/picoruby-ws2812", branch: "main"
      end
    RUBY

    gems = Picotorokko::MrbgemsDSL.new(dsl_code, "xtensa-esp").gems

    assert_equal 1, gems.length
    gem = gems[0]
    assert_equal :github, gem[:source_type]
    assert_equal "ksbmyk/picoruby-ws2812", gem[:source]
    assert_equal "main", gem[:branch]
    assert_nil gem[:ref]
    assert_nil gem[:cmake]
  end
end
