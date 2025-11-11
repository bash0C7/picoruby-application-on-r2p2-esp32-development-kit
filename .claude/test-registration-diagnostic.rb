#!/usr/bin/env ruby
# test-unit registration diagnostic tool
# 複数テストファイルの組み合わせで何個のテストが登録されるかを計測
# Purpose: バイナリサーチで問題のあるファイル組み合わせを特定

require 'fileutils'
require 'open3'
require 'json'

TEST_FILES = [
  "test/commands/cli_test.rb",
  "test/commands/device_test.rb",
  "test/commands/env_test.rb",
  "test/commands/mrbgems_test.rb",
  "test/commands/rubocop_test.rb",
  "test/env_test.rb",
  "test/lib/env_constants_test.rb",
  "test/pra_test.rb",
  "test/rake_task_extractor_test.rb"
].freeze

INDIVIDUAL_COUNTS = {
  "test/commands/cli_test.rb" => 27,
  "test/commands/device_test.rb" => 33,
  "test/commands/env_test.rb" => 66,
  "test/commands/mrbgems_test.rb" => 97,
  "test/commands/rubocop_test.rb" => 86,
  "test/env_test.rb" => 81,
  "test/lib/env_constants_test.rb" => 62,
  "test/pra_test.rb" => 36,
  "test/rake_task_extractor_test.rb" => 63
}.freeze

def run_test_loader(files)
  # rake_test_loader.rb シミュレーション
  cmd = [
    "ruby",
    "-w",
    "-I", "lib:test:lib",
    "-W1"
  ]

  # Temporary test loader script
  loader_script = <<-RUBY
$LOAD_PATH.unshift "lib"
$LOAD_PATH.unshift "test"

require "simplecov"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/"
  add_filter "/lib/pra/templates/"
  enable_coverage :branch
  minimum_coverage line: 75, branch: 55
end
require "simplecov-cobertura"
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

require "pra"
require "test-unit"
require "tmpdir"

ENV["PTRK_USER_ROOT"] = Dir.mktmpdir("ptrk_test_")

# ファイルをロード
#{files.map { |f| "require_relative \"../../#{f}\"" }.join("\n")}

# test-unit が登録したテスト数を報告
exit 0
RUBY

  cmd << "-e" << loader_script

  stdout, stderr, status = Open3.capture3(*cmd)

  # SimpleCov の出力から test 数を抽出
  if stdout =~ /(\d+) tests?,/
    Integer($1)
  else
    0
  end
rescue StandardError => e
  puts "ERROR running test loader: #{e.message}"
  0
end

puts "=" * 80
puts "TEST-UNIT REGISTRATION DIAGNOSTIC"
puts "=" * 80

results = {}

# 1. Individual files (baseline)
puts "\n1. Individual file registration:"
puts "-" * 80
individual_total = 0
TEST_FILES.each do |file|
  expected = INDIVIDUAL_COUNTS[file]
  puts "  #{file.ljust(45)} => #{expected} tests (expected)"
  individual_total += expected
end
puts "-" * 80
puts "  TOTAL EXPECTED: #{individual_total} tests"

# 2. Binary search for problem files
puts "\n2. Binary search for registration failure:"
puts "-" * 80

# All files together
puts "  Testing all 9 files together..."
all_count = run_test_loader(TEST_FILES)
puts "  All 9 files: #{all_count} tests registered"
results["all_9"] = all_count

if all_count < individual_total / 2
  puts "\n  ⚠️  SEVERE: Only #{all_count}/#{individual_total} tests registered (#{(100.0 * all_count / individual_total).round(1)}%)"
  puts "     → Indicates test-unit registration failure in multi-file scenario"

  # Binary search: split files
  mid = TEST_FILES.length / 2
  left_files = TEST_FILES[0...mid]
  right_files = TEST_FILES[mid..-1]

  left_count = run_test_loader(left_files)
  right_count = run_test_loader(right_files)

  puts "\n  Binary split results:"
  puts "    Left  (#{left_files.length} files): #{left_count} tests"
  puts "    Right (#{right_files.length} files): #{right_count} tests"

  results["left_#{left_files.length}"] = left_count
  results["right_#{right_files.length}"] = right_count

  # Recursive binary search on the problematic side
  problem_side = right_count < left_count ? right_files : left_files
  puts "\n  Investigating problem side: #{problem_side.map { |f| File.basename(f) }.join(', ')}"

  # Try each file individually to identify culprit
  puts "\n3. Searching for problematic file combinations:"
  puts "-" * 80

  problem_side.each do |file|
    count = run_test_loader([file])
    expected = INDIVIDUAL_COUNTS[file]
    status = count == expected ? "✓" : "⚠️"
    puts "  #{status} #{file.ljust(45)} => #{count}/#{expected}"
  end
end

puts "\n4. Summary:"
puts "-" * 80
puts "  Registered tests (Rake): #{all_count}"
puts "  Expected tests (sum): #{individual_total}"
puts "  Missing: #{individual_total - all_count} (#{(100.0 * (individual_total - all_count) / individual_total).round(1)}%)"
puts "=" * 80
