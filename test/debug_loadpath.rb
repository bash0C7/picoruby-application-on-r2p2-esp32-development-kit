#!/usr/bin/env ruby
# frozen_string_literal: true

# $LOAD_PATH の状態を確認

puts "[1] 初期状態の $LOAD_PATH (lib/test 関連のみ):"
puts $LOAD_PATH.grep(/lib|test/).inspect

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
puts "\n[2] lib 追加後:"
puts $LOAD_PATH.grep(/lib|test/).inspect

require_relative "test_helper"
puts "\n[3] test_helper 読み込み後:"
puts $LOAD_PATH.grep(/lib|test/).inspect

# test/commands/ に関連するパスをチェック
puts "\n[4] test/commands/ 関連:"
puts "  test/commands/device.rb 存在: #{File.exist?('test/commands/device.rb')}"
puts "  test/commands/device_test.rb 存在: #{File.exist?('test/commands/device_test.rb')}"
puts "  lib/picotorokko/commands/device.rb 存在: #{File.exist?('lib/picotorokko/commands/device.rb')}"

# require がどのファイルを読み込むかチェック
puts "\n[5] require 解決テスト:"
begin
  path = $LOAD_PATH.find { |dir| File.exist?(File.join(dir, "commands/device.rb")) }
  puts "  'commands/device.rb' は見つかる: #{path ? path : 'NO'}"
rescue StandardError => e
  puts "  Error: #{e.message}"
end

puts "\n[6] device_test.rb を読み込む前の Test::Unit::TestCase サブクラス数:"
count_before = ObjectSpace.each_object(Class).count { |k| k < Test::Unit::TestCase rescue false }
puts "  #{count_before}"

require_relative "commands/device_test"

puts "\n[7] device_test.rb 読み込み後の Test::Unit::TestCase サブクラス数:"
count_after = ObjectSpace.each_object(Class).count { |k| k < Test::Unit::TestCase rescue false }
puts "  #{count_after}"
puts "  新規追加: #{count_after - count_before}"

puts "\n[8] PraCommandsDeviceTest のテストメソッド数:"
if defined?(PraCommandsDeviceTest)
  test_methods = PraCommandsDeviceTest.public_instance_methods(false).grep(/^test_/)
  puts "  #{test_methods.size}"
  
  # Test::Unit が認識しているテストを確認
  puts "\n[9] Test::Unit が認識しているテスト:"
  ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name rescue false }.each do |test_case|
    test_count = test_case.public_instance_methods(false).grep(/^test_/).size
    puts "  #{test_case.name}: #{test_count} tests"
  end
else
  puts "  PraCommandsDeviceTest が定義されていない"
end
