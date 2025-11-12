#!/usr/bin/env ruby
# frozen_string_literal: true

# exit 呼び出しをトレース

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)

# exit をトレースする（test_helper より前に設定）
module Kernel
  alias_method :original_exit, :exit
  
  def exit(*args)
    unless $exit_traced
      $exit_traced = true
      puts "\n[EXIT CALLED] args=#{args.inspect}"
      puts "  Caller:"
      caller[0..15].each_with_index do |line, i|
        puts "    #{i}. #{line}"
      end
      puts ""
    end
    original_exit(*args)
  end
end

require_relative "test_helper"
require_relative "commands/device_test"

puts "[1] device_test.rb loaded, running tests with exit tracing..."

# Test::Unit::AutoRunner を実行
exit Test::Unit::AutoRunner.run
