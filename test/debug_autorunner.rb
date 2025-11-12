#!/usr/bin/env ruby
# frozen_string_literal: true

# Test::Unit::AutoRunner の動作をトレース

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"
require_relative "commands/device_test"

puts "[1] Checking suite.tests for 'rake task proxy'..."

rake_proxy_class = ObjectSpace.each_object(Class).find { |k| k.name =~ /rake task proxy/ && k < Test::Unit::TestCase }

if rake_proxy_class
  suite = rake_proxy_class.suite
  puts "  Suite has #{suite.tests.size} tests:"
  suite.tests.each_with_index do |test, i|
    puts "    #{i + 1}. #{test.method_name} (#{test.class.name})"
  end
end

puts "\n[2] Now running Test::Unit::AutoRunner.run..."
puts "  (Watch which tests actually execute)\n\n"

# Test::Unit の run メソッドをモンキーパッチして、実行されるテストをトレース
module Test
  module Unit
    class TestCase
      alias_method :original_run, :run
      
      def run(result)
        if self.class.name =~ /rake task proxy/
          puts "[TEST EXECUTING] #{self.class.name}::#{@method_name}"
        end
        original_run(result)
      end
    end
  end
end

# AutoRunner を実行
exit Test::Unit::AutoRunner.run
