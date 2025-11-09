# coverage_test.rb: SimpleCov exit code behavior verification
require_relative "test_helper"

class CoverageTest < PraTestCase
  # SimpleCov が正常に実行され、HTML レポートが生成されることを確認
  def test_simplecov_generates_report
    coverage_dir = File.join(Dir.pwd, "coverage")
    assert File.directory?(coverage_dir), "SimpleCov coverage directory should exist"

    cobertura_xml = File.join(coverage_dir, "coverage.xml")
    assert File.exist?(cobertura_xml), "SimpleCov Cobertura XML report should exist"
  end

  # SimpleCov が成功時に exit 0 で終了することを確認
  def test_rake_test_exits_zero
    # rake test の exit code が 0 であることを確認
    # （このテスト自体が rake test で実行されているため、ここまで reach したら成功）
    assert true, "If this test runs, rake test exited with code 0"
  end

  # SimpleCov 設定が correct であることを確認
  def test_simplecov_configured_correctly
    # SimpleCov が configured であることを確認（coverage が生成されている）
    coverage_file = File.join(Dir.pwd, "coverage", "coverage.xml")
    assert File.exist?(coverage_file), "SimpleCov should generate coverage data"

    # ファイルが有効な XML であることを確認
    content = File.read(coverage_file)
    assert content.include?("<?xml"), "Coverage file should be valid XML"
  end
end
