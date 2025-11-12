#!/usr/bin/env ruby
# frozen_string_literal: true

# テストメソッドの登録を TracePoint で追跡

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)  # プロジェクトルートを追加（test/ が見えるように）
$LOAD_PATH.unshift File.expand_path(".", __dir__)  # test ディレクトリ自体も追加
require_relative "test_helper"

# TracePoint でテストメソッドの定義を追跡
test_methods_defined = []
trace = TracePoint.new(:call) do |tp|
  if tp.defined_class == Test::Unit::TestCase.singleton_class && tp.method_id == :test
    # Test::Unit::TestCase.test メソッドが呼ばれたとき（テストメソッドが定義されたとき）
    name = begin
      tp.binding.local_variable_get(:name)
    rescue StandardError
      "unknown"
    end
    test_methods_defined << {
      name: name,
      location: "#{tp.path}:#{tp.lineno}"
    }
  end
end

trace.enable

puts "[1] device_test.rb を読み込む前:"
puts "  Test::Unit::TestCase サブクラス数: #{ObjectSpace.each_object(Class).count { |k| k < Test::Unit::TestCase rescue false }}"

require_relative "commands/device_test"

trace.disable

puts "\n[2] device_test.rb 読み込み後:"
puts "  Test::Unit::TestCase サブクラス数: #{ObjectSpace.each_object(Class).count { |k| k < Test::Unit::TestCase rescue false }}"

puts "\n[3] 定義されたテストメソッド (#{test_methods_defined.size} 個):"
test_methods_defined.each_with_index do |info, i|
  puts "  #{i + 1}. #{info[:name]} (#{info[:location]})"
end

puts "\n[4] Test::Unit が認識しているテスト:"
ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name rescue false }.each do |test_case|
  test_count = test_case.public_instance_methods(false).grep(/^test_/).size
  puts "  #{test_case.name}: #{test_count} tests"
end
