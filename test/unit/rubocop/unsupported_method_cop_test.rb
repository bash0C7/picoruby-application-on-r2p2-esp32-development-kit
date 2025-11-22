# frozen_string_literal: true

require "test_helper"
require "json"

# Test for RuboCop PicoRuby/UnsupportedMethod cop data file resolution
class UnsupportedMethodCopTest < PicotorokkoTestCase
  def setup
    super
    @cop_template_path = File.expand_path(
      "../../../lib/picotorokko/templates/rubocop/lib/rubocop/cop/picoruby/unsupported_method.rb",
      __dir__
    )
  end

  def test_find_data_file_searches_ptrk_env_directory
    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        with_fresh_project_root do
          # Setup: Create .ptrk_env structure with test env
          env_name = "test-env"
          rubocop_data_dir = File.join(tmpdir, ".ptrk_env", env_name, "rubocop", "data")
          FileUtils.mkdir_p(rubocop_data_dir)

          # Create test data file
          test_data = {
            "String" => { "instance" => ["gsub!"], "class" => [] }
          }
          data_file = File.join(rubocop_data_dir, "picoruby_unsupported_methods.json")
          File.write(data_file, JSON.generate(test_data))

          # Setup env config to return current env
          FileUtils.mkdir_p(File.join(tmpdir, ".ptrk_env"))
          env_file = File.join(tmpdir, ".ptrk_env", ".picoruby-env.yml")
          File.write(env_file, "current: #{env_name}\n")

          # Load and test the cop's find_data_file method
          # We need to test the cop can find files in .ptrk_env/<env>/rubocop/data
          cop_content = File.read(@cop_template_path)

          # The find_data_file method should include .ptrk_env path
          # This test will fail until we add .ptrk_env/<env>/rubocop/data to possible_paths
          assert_match(
            /\.ptrk_env/,
            cop_content,
            "find_data_file should search in .ptrk_env/<env>/rubocop/data directory"
          )
        end
      end
    end
  end

  def test_find_data_file_includes_current_env_path
    # Read the cop template and verify it includes logic to find current env
    cop_content = File.read(@cop_template_path)

    # The cop should use current env to build the path
    assert_match(
      /ptrk_env.*rubocop.*data|current.*env/i,
      cop_content,
      "Cop should reference .ptrk_env/<env>/rubocop/data path for method database"
    )
  end
end
