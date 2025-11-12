#!/usr/bin/env ruby
# frozen_string_literal: true

# Line 321 テスト: omit + 後続コード

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "=" * 80
puts "VARIATION 3: Line 321 test has OMIT + unreachable code after"
puts "=" * 80

class Variation3Test < PraTestCase
  include SystemCommandMocking
  
  sub_test_case "device tasks command" do
    test "raises error when environment not found" do
      assert_true(true)
    end
    
    test "shows available tasks for environment" do
      omit "Thor tasks command breaks test-unit registration"
      
      # omit の後にコードがある（実行されないはず）
      with_fresh_project_root do
        Dir.mktmpdir do |tmpdir|
          Dir.chdir(tmpdir)
          begin
            setup_test_environment('test-env')
            
            with_esp_env_mocking do |_mock|
              output = capture_stdout do
                Picotorokko::Commands::Device.start(['tasks', '--env', 'test-env'])
              end
              
              assert_match(/Available R2P2-ESP32 tasks for environment: test-env/, output)
              assert_match(/=+/, output)
            end
          end
        end
      end
    end
  end
  
  sub_test_case "rake task proxy" do
    test "test 1" do
      assert_true(true)
    end
    
    test "test 2" do
      assert_true(true)
    end
  end
end

# AutoRunner を実行
result = Test::Unit::AutoRunner.run
puts "\nResult: #{result ? 'SUCCESS' : 'FAILURE'}"
