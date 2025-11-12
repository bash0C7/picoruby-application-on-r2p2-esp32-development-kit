#!/usr/bin/env ruby
# frozen_string_literal: true

# Test::Unit のテスト収集プロセスをトレース

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "[1] Loading device_test.rb..."
require_relative "commands/device_test"

puts "\n[2] Inspecting Test::Unit internal structure..."

# Test::Unit::TestCase のサブクラスを確認
test_case_classes = ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name rescue false }

puts "  Found #{test_case_classes.size} Test::Unit::TestCase subclasses"

# "rake task proxy" sub_test_case を詳しく調べる
rake_proxy_class = test_case_classes.find { |k| k.name =~ /rake task proxy/ }

if rake_proxy_class
  puts "\n[3] Analyzing '#{rake_proxy_class.name}':"
  
  # Test::Unit が使う内部データ構造を確認
  if rake_proxy_class.respond_to?(:suite)
    suite = rake_proxy_class.suite
    puts "    suite: #{suite.class.name}"
    puts "    suite.tests: #{suite.tests.size} tests"
    
    if suite.tests.size > 0
      puts "    Test names:"
      suite.tests.each_with_index do |test, i|
        puts "      #{i + 1}. #{test.method_name}"
      end
    end
  else
    puts "    suite method not available"
  end
  
  # test_order を確認
  if rake_proxy_class.respond_to?(:test_order)
    puts "    test_order: #{rake_proxy_class.test_order}"
  end
  
  # startup/shutdown hooks を確認
  if rake_proxy_class.respond_to?(:startup)
    puts "    startup defined: yes"
  end
  
  # Public instance methods
  test_methods = rake_proxy_class.public_instance_methods(false).grep(/^test_/)
  puts "    public_instance_methods(false) test_*: #{test_methods.size}"
  
  # All instance methods (including inherited)
  all_test_methods = rake_proxy_class.public_instance_methods(true).grep(/^test_/)
  puts "    public_instance_methods(true) test_*: #{all_test_methods.size}"
  
  if all_test_methods.size > 0
    puts "    All test method names:"
    all_test_methods.each_with_index do |method_name, i|
      owner = rake_proxy_class.public_instance_method(method_name).owner
      puts "      #{i + 1}. #{method_name} (owner: #{owner.name})"
    end
  end
end

puts "\n[4] Done"
