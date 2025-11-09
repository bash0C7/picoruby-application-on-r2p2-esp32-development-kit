# test_helper_test.rb: テスト基盤の設定テスト
require_relative "test_helper"

class TestHelperTest < PraTestCase
  # PTRK_USER_ROOT が env 変数で設定されていることを確認
  def test_ptrk_user_root_is_set
    assert ENV.fetch("PTRK_USER_ROOT", nil), "ENV['PTRK_USER_ROOT'] should be set"
    assert File.directory?(ENV.fetch("PTRK_USER_ROOT", nil)), "PTRK_USER_ROOT should be a valid directory"
  end

  # PTRK_USER_ROOT が一時ディレクトリであることを確認
  def test_ptrk_user_root_is_temp_directory
    ptrk_root = ENV.fetch("PTRK_USER_ROOT", nil)
    # Dir.mktmpdir で作成された一時ディレクトリは /tmp/ または /var/folders/ に配置される
    is_temp_dir = ptrk_root.include?("tmp") || ptrk_root.include?("var/folders")
    assert is_temp_dir, "PTRK_USER_ROOT should be a temp directory: #{ptrk_root}"
  end

  # verify_gem_root_clean! メソッドが存在することを確認
  def test_verify_gem_root_clean_method_exists
    # PraTestCase が private_instance_methods に verify_gem_root_clean! を持つことを確認
    private_methods = PraTestCase.private_instance_methods
    assert private_methods.include?(:verify_gem_root_clean!), "PraTestCase should have verify_gem_root_clean! method"
  end

  # gem root（現在の作業ディレクトリ）が pollution されていないことを確認
  def test_gem_root_clean
    original_files = Dir.glob("#{File.expand_path("../..", __dir__)}/{build,ptrk_env,.cache,patch}").count

    # テスト実行後、これらのディレクトリが作成されていないことを確認
    assert_equal 0, original_files, "Gem root should not be polluted with build, ptrk_env, .cache, or patch directories"
  end
end
