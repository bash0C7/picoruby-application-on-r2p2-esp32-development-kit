#!/usr/bin/env ruby
# frozen_string_literal: true

# Line 355 のテスト実行をトレース

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

# at_exit フックをトレース
puts "[1] Registering at_exit hook tracer..."
at_exit_count = 0
TracePoint.new(:call) do |tp|
  if tp.method_id == :at_exit
    at_exit_count += 1
    puts "  [at_exit CALL ##{at_exit_count}] from #{tp.path}:#{tp.lineno}"
  end
end.enable

# exit 呼び出しをトレース
exit_trace = TracePoint.new(:call) do |tp|
  if tp.method_id == :exit || tp.method_id == :exit!
    puts "  [EXIT CALL] #{tp.method_id} from #{tp.path}:#{tp.lineno}"
    puts "    Caller: #{caller[0..3].join("\n            ")}"
  end
end
exit_trace.enable

puts "[2] Loading device_test.rb..."
require_relative "commands/device_test"

puts "\n[3] Checking registered tests before AutoRunner..."
ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name =~ /rake task proxy/ }.each do |klass|
  puts "  #{klass.name}:"
  # Test::Unit::TestCase のサブクラスにある test methods を確認
  test_methods = klass.public_instance_methods(true).grep(/^test_/).select do |m|
    klass.public_instance_method(m).owner.name =~ /rake task proxy/
  end
  puts "    test methods: #{test_methods.size}"
end

puts "\n[4] Device_test.rb loaded successfully"
puts "  at_exit hooks called during load: #{at_exit_count}"

exit_trace.disable
