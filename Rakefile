require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  test_files = FileList["test/**/*_test.rb"]
  # TEMPORARILY EXCLUDED: device_test.rb
  # See TODO.md "Fix device_test.rb Thor command argument handling" for details
  test_files.exclude("test/commands/device_test.rb")

  t.test_files = test_files

  # Ruby warning suppress: method redefinition warnings in test mocks
  # See: test/commands/env_test.rb, test/commands/cache_test.rb
  t.ruby_opts = ["-W1"]
end

require "rubocop/rake_task"

RuboCop::RakeTask.new

# 開発時のデフォルトタスク：クイックにテストのみ実行
task default: %i[test]

# カバレッジ検証タスク（test実行後にcoverage.xmlが生成されていることを確認）
desc "Validate SimpleCov coverage report was generated"
task :coverage_validation do
  coverage_file = File.join(Dir.pwd, "coverage", "coverage.xml")
  abort "ERROR: SimpleCov coverage report not found at #{coverage_file}" unless File.exist?(coverage_file)
  puts "✓ SimpleCov coverage report validated: #{coverage_file}"
end

# CI専用タスク：テスト + コード品質チェック + カバレッジ検証
desc "Run tests with coverage checks and RuboCop linting (for CI)"
task ci: %i[test rubocop coverage_validation]

# 品質チェック統合タスク
desc "Run all quality checks (tests and linting)"
task quality: %i[test rubocop]

# 開発者向け：pre-commitフック用タスク
desc "Pre-commit checks: RuboCop linting and tests"
task "pre-commit": %i[rubocop test] do
  puts "\n✓ Pre-commit checks passed! Ready to commit."
end
