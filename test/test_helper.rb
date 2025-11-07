# frozen_string_literal: true

# カバレッジ測定の開始（他のrequireより前に実行）
require "simplecov"
require "simplecov-lcov"

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.single_report_path = "coverage/lcov.info"
end

SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/"
  enable_coverage :branch
  # CI環境でのみカバレッジチェックを有効化
  minimum_coverage line: 80, branch: 50 if ENV["CI"]
end

# HTML と LCOV の両方を出力（Codecov v4 対応）
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::LcovFormatter
])

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "pra"

require "test-unit"
