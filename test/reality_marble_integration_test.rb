require "test_helper"
require "reality_marble"

class RealityMarbleIntegrationTest < Test::Unit::TestCase
  # reality_marble gem の基本機能を検証
  sub_test_case "Reality Marble mocking" do
    test "mocks File.exist? method" do
      marble = RealityMarble.chant { expect(File, :exist?) { |path| path == "/mock/path" } }
      marble.activate { assert_mock_file_exists }
    end

    test "mocks multiple expectations" do
      marble = RealityMarble.chant do
        expect(File, :exist?) { |path| path.start_with?("/etc/") }
        expect(Dir, :glob) { |_pattern| ["/etc/config"] }
      end
      marble.activate { assert_mock_multi_expectations }
    end

    test "context resets after deactivation" do
      marble = RealityMarble.chant { expect(File, :exist?) { true } }
      marble.activate { assert File.exist?("/any/path") }

      # リセット後は元の動作に戻る
      assert_false File.exist?("/nonexistent")
    end
  end

  # picotorokko テストでの実用例
  sub_test_case "Usage with picotorokko" do
    test "mocks Dir operations for testing" do
      marble = RealityMarble.chant { expect(Dir, :glob) { |_pattern| ["/mock/dir1", "/mock/dir2"] } }
      marble.activate { assert_mock_dir_operations }
    end
  end

  teardown do
    # コンテキストをリセット
    RealityMarble::Context.reset_current
  end

  private

  def assert_mock_file_exists
    assert File.exist?("/mock/path")
    assert_false File.exist?("/other/path")
  end

  def assert_mock_multi_expectations
    assert File.exist?("/etc/hosts")
    assert_equal ["/etc/config"], Dir.glob("/etc/*")
  end

  def assert_mock_dir_operations
    result = Dir.glob("/mock/*")
    assert_equal ["/mock/dir1", "/mock/dir2"], result
  end
end
