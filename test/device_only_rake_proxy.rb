require "test_helper"
require "tmpdir"
require "fileutils"
require "stringio"

class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking
  sub_test_case "rake task proxy" do
    test "delegates custom_task to R2P2-ESP32 rake task" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |_mock|
              # custom_task が Rakefile に存在するため、method_missing で委譲される
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
              end

              # タスク委譲メッセージが出力されることを確認
              assert_match(/Delegating to R2P2-ESP32 task: custom_task/, output)
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end

    test "raises error when rake task does not exist" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking(fail_command: true) do |_mock|
              assert_raise(SystemExit) do
                capture_stdout do
                  Picotorokko::Commands::Device.start(['nonexistent_task', '--env', 'test-env'])
                end
              end
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end

    test "delegates rake task with explicit env" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |_mock|
              # custom_task が Rakefile に存在するため、method_missing で委譲される
              # 環境名は --env で明示的に指定する（暗黙のカレント環境は存在しない）
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
              end

              # タスク委譲メッセージが出力されることを確認
              assert_match(/Delegating to R2P2-ESP32 task: custom_task/, output)
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end

    test "does not delegate Thor internal methods" do
      # _で始まるメソッドはmethod_missingで処理されない
      device = Picotorokko::Commands::Device.new

      # respond_to_missing? が false を返すことを確認
      assert_false(device.respond_to?(:_internal_method))
    end

    test "help command displays available tasks" do
      # OMITTED: Thor's help command breaks test-unit registration globally
      # - This test causes 108 other tests to fail to register when loaded with full test suite
      # - Root cause: Thor help + capture_stdout + mocking context interferes with test-unit hooks
      # - Priority: LOW (display-only feature, non-critical functionality)
      # - See: TODO.md [TODO-INFRASTRUCTURE-DEVICE-TEST]
      omit "Thor help command breaks test-unit registration - see TODO.md [TODO-INFRASTRUCTURE-DEVICE-TEST]"

      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            # NOTE: tmpdir内で新しい環境を構築（前回のテスト実行の影響は受けない）

            setup_test_environment('test-env')

            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['help', '--env', 'test-env'])
              end

              # ヘルプメッセージが表示されることを確認
              assert_match(/Available R2P2-ESP32 tasks for environment: test-env/, output)
            end

            # Directory change is handled by with_fresh_project_root
          end
        end
      end
    end
  end

  private

  def capture_stdout
    original_stdout = $stdout
    original_stderr = $stderr
    $stdout = StringIO.new
    $stderr = StringIO.new # stderr もキャプチャして捨てる（rake エラーメッセージを抑制）
    yield
    $stdout.string
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end

  def setup_test_environment(env_name)
    r2p2_info = { "commit" => "abc1234", "timestamp" => "20250101_120000" }
    esp32_info = { "commit" => "def5678", "timestamp" => "20250102_120000" }
    picoruby_info = { "commit" => "ghi9012", "timestamp" => "20250103_120000" }

    Picotorokko::Env.set_environment(env_name, r2p2_info, esp32_info, picoruby_info)

    # Phase 4: get_build_path uses env_name, not env_hash
    build_path = Picotorokko::Env.get_build_path(env_name)
    r2p2_path = File.join(build_path, "R2P2-ESP32")
    FileUtils.mkdir_p(r2p2_path)

    # テスト用 Rakefile をコピー
    mock_rakefile = File.expand_path("../fixtures/R2P2-ESP32/Rakefile", __dir__)
    FileUtils.cp(mock_rakefile, File.join(r2p2_path, "Rakefile"))

    [env_name, r2p2_path]
  end

  def setup_test_environment_with_current(env_name)
    env_name, r2p2_path = setup_test_environment(env_name)

    # Set current environment for default resolution
    Picotorokko::Env.set_current_env(env_name)

    [env_name, r2p2_path]
  end
end
