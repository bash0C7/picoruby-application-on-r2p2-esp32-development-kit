#!/usr/bin/env ruby
# frozen_string_literal: true

# Line 321 テスト: omit のみ

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "=" * 80
puts "VARIATION 2: Line 321 test has OMIT ONLY"
puts "=" * 80

class Variation2Test < PraTestCase
  include SystemCommandMocking
  
  sub_test_case "device tasks command" do
    test "raises error when environment not found" do
      assert_true(true)
    end
    
    test "shows available tasks for environment" do
      omit "Thor tasks command breaks test-unit registration"
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
