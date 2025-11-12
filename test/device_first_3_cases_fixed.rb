require "test_helper"
require "tmpdir"
require "fileutils"
require "stringio"

# ========================================================================
# ⚠️  ONE TEST OMITTED (line 426-455)
# ========================================================================
# Test "help command displays available tasks" is omitted due to Thor + test-unit conflict
# See: TODO.md [TODO-INFRASTRUCTURE-DEVICE-TEST]
#
# Status:
#   - 18 of 19 tests run successfully in CI ✓
#   - 1 test omitted: "help command displays available tasks" (display-only, low priority)
#   - Omit reason: Thor's help command breaks test-unit registration globally
#
# All other device tests are fully functional and included in CI
# ========================================================================

# SystemCommandMocking is now defined in test_helper.rb

class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking

  # NOTE: SystemCommandMocking::SystemRefinement is NOT used in device_test.rb
  # - Refinement-based system() mocking doesn't work across lexical scopes
  # - device_test.rb uses with_esp_env_mocking instead (mocks Picotorokko::Env.execute_with_esp_env)
  # - See: test_helper.rb with_esp_env_mocking for device test mocking strategy

  # device flash コマンドのテスト
  sub_test_case "device flash command" do
    test "raises error when environment not found" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['flash', '--env', 'nonexistent-env'])
            end
          end

          # Directory change is handled by with_fresh_project_root
        end
      end
    end

    test "raises error when no current environment is set" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['flash', '--env', 'current'])
            end
          end

          # Directory change is handled by with_fresh_project_root
        end
      end
    end

    test "raises error when build environment not found" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            # テスト用の環境定義を作成するが、ビルド環境は作成しない
            r2p2_info = { 'commit' => 'abc1234', 'timestamp' => '20250101_120000' }
            esp32_info = { 'commit' => 'def5678', 'timestamp' => '20250102_120000' }
            picoruby_info = { 'commit' => 'ghi9012', 'timestamp' => '20250103_120000' }

            Picotorokko::Env.set_environment('test-env', r2p2_info, esp32_info, picoruby_info)

            # ビルド環境ディレクトリが存在する場合は削除（前のテストの残骸をクリーンアップ）
            build_path = Picotorokko::Env.get_build_path('test-env')
            FileUtils.rm_rf(build_path) if Dir.exist?(build_path)

            assert_raise(RuntimeError) do
              capture_stdout do
                Picotorokko::Commands::Device.start(['flash', '--env', 'test-env'])
              end
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end

    test "shows message when flashing" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['flash', '--env', 'test-env'])
              end

              # 出力を確認
              assert_match(/Flashing: test-env/, output)
              assert_match(/✓ Flash completed/, output)

              # コマンド実行の検証（rake flash が実行されたことを確認）
              assert_equal(1, mock[:commands_executed].count { |cmd| cmd.include?('rake flash') })
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end
  end

  # device monitor コマンドのテスト
  sub_test_case "device monitor command" do
    test "raises error when environment not found" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['monitor', '--env', 'nonexistent-env'])
            end
          end

          # Directory change is handled by with_fresh_project_root
        end
      end
    end

    test "raises error when no current environment is set" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['monitor', '--env', 'current'])
            end
          end

          # Directory change is handled by with_fresh_project_root
        end
      end
    end

    test "shows message when monitoring" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['monitor', '--env', 'test-env'])
              end

              # 出力を確認
              assert_match(/Monitoring: test-env/, output)
              assert_match(/Press Ctrl\+C to exit/, output)
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end
  end

  # device build コマンドのテスト
  sub_test_case "device build command" do
    test "raises error when environment not found" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)

          # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

          assert_raise(RuntimeError) do
            capture_stdout do
              Picotorokko::Commands::Device.start(['build', '--env', 'nonexistent-env'])
            end
          end

          # Directory change is handled by with_fresh_project_root
        end
      end
    end

    test "shows message when building" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['build', '--env', 'test-env'])
              end

              # 出力を確認
              assert_match(/Building: test-env/, output)
              assert_match(/✓ Build completed/, output)
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end
  end

  # device setup_esp32 コマンドのテスト
end
