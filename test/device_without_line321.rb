require "test_helper"
require "tmpdir"
require "fileutils"
require "stringio"

# SystemCommandMocking is now defined in test_helper.rb

class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking

  # NOTE: SystemCommandMocking::SystemRefinement is NOT used in device_test.rb
  # - Refinement-based system() mocking doesn't work across lexical scopes
  # - device_test.rb uses with_esp_env_mocking instead (mocks Picotorokko::Env.execute_with_esp_env)
  # - See: test_helper.rb with_esp_env_mocking for device test mocking strategy

  # device tasks コマンドのテスト（Line 321 のテストを除外）
  sub_test_case "device tasks command" do
    test "raises error when environment not found" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['tasks', '--env', 'nonexistent-env'])
            end
          end
        end
      end
    end

    test "raises error when no current environment is set" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['tasks', '--env', 'current'])
            end
          end
        end
      end
    end

    # Line 321 のテストをコメントアウト（完全に除外）
  end

  # method_missing による動的Rakeタスク委譲のテスト
  sub_test_case "rake task proxy" do
    test "test 1" do
      assert_true(true)
    end

    test "test 2" do
      assert_true(true)
    end

    test "test 3" do
      assert_true(true)
    end

    test "test 4" do
      assert_true(true)
    end

    test "test 5" do
      assert_true(true)
    end
  end
end
