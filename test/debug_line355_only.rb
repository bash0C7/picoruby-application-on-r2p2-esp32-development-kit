#!/usr/bin/env ruby
# frozen_string_literal: true

# Line 355 のテストだけを実行

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

# exit と at_exit をトレース
at_exit_count = 0
original_at_exit = method(:at_exit)

define_method(:at_exit) do |&block|
  at_exit_count += 1
  puts "[at_exit REGISTERED ##{at_exit_count}] from #{caller[0]}"
  original_at_exit.call(&block)
end

exit_called = false
module Kernel
  alias_method :original_exit, :exit
  
  def exit(*args)
    unless $exit_traced
      $exit_traced = true
      puts "[EXIT CALLED] args=#{args.inspect}"
      puts "  Caller:"
      caller[0..10].each_with_index do |line, i|
        puts "    #{i}. #{line}"
      end
    end
    original_exit(*args)
  end
end

puts "[1] Loading test_helper and device_test..."

# device_test.rb から Line 355 のテストだけを抽出
class PraCommandsDeviceTest < PraTestCase
  include SystemCommandMocking
  
  sub_test_case "rake task proxy" do
    test "delegates custom_task to R2P2-ESP32 rake task" do
      puts "  [TEST STARTED] delegates custom_task..."
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                puts "    [BEFORE Device.start]"
                Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
                puts "    [AFTER Device.start]"
              end
              
              assert_match(/Delegating to R2P2-ESP32 task: custom_task/, output)
            end
          end
        end
      end
      puts "  [TEST FINISHED] delegates custom_task"
    end
  end
end

puts "\n[2] Running tests..."
puts "  at_exit hooks registered: #{at_exit_count}"

# Test::Unit::AutoRunner を実行
exit Test::Unit::AutoRunner.run
