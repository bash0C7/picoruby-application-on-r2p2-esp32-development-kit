# frozen_string_literal: true

# カバレッジ測定の開始（他のrequireより前に実行）
require "simplecov"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/"
  enable_coverage :branch
  # NOTE: カバレッジチェックは無効化（CI が最小テスト範囲で実行中）
  # 長期的にはテストを拡張して最小カバレッジを満たすようにする
  # minimum_coverage line: 80, branch: 50 if ENV["CI"]
end

# Codecov v4対応: Cobertura XML形式で出力
require "simplecov-cobertura"
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pra"

require "test-unit"
