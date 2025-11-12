require "test_helper"
require "tmpdir"
require "fileutils"
require "stringio"

class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking

  # method_missing による動的Rakeタスク委譲のテスト
  sub_test_case "rake task proxy" do
    test "delegates custom_task to R2P2-ESP32 rake task" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
              end
              
              assert_match(/Delegating to R2P2-ESP32 task: custom_task/, output)
            end
          end
        end
      end
    end

    test "raises error when rake task does not exist" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking(fail_command: true) do |_mock|
              assert_raise(SystemExit) do
                capture_stdout do
                  Picotorokko::Commands::Device.start(['nonexistent_task', '--env', 'test-env'])
                end
              end
            end
          end
        end
      end
    end

    test "delegates rake task with explicit env" do
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
              end
              
              assert_match(/Delegating to R2P2-ESP32 task: custom_task/, output)
            end
          end
        end
      end
    end

    test "does not delegate Thor internal methods" do
      device = Picotorokko::Commands::Device.new
      assert_false(device.respond_to?(:_internal_method))
    end

    test "help command displays available tasks" do
      omit "Thor help command breaks test-unit registration - see TODO.md [TODO-INFRASTRUCTURE-DEVICE-TEST]"
      
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['help', 'custom_task'])
              end
              
              assert_match(/Commands:/, output)
            end
          end
        end
      end
    end
  end
end
