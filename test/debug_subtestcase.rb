#!/usr/bin/env ruby
# frozen_string_literal: true

# sub_test_case のテスト登録を詳しく調査

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "[1] device_test.rb を読み込む前:"
puts "  Test::Unit::TestCase サブクラス: #{ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name rescue false }.map(&:name)}"

require_relative "commands/device_test"

puts "\n[2] device_test.rb 読み込み後:"
puts "  Test::Unit::TestCase サブクラス:"
ObjectSpace.each_object(Class).select { |k| k < Test::Unit::TestCase && k.name rescue false }.each do |klass|
  puts "    #{klass.name}"
  puts "      親クラス: #{klass.superclass.name}"
  puts "      public_instance_methods(false): #{klass.public_instance_methods(false).grep(/^test_/)}"
  puts "      instance_methods(false): #{klass.instance_methods(false).grep(/^test_/)}"
end

puts "\n[3] PraCommandsDeviceTest の階層:"
if defined?(PraCommandsDeviceTest)
  klass = PraCommandsDeviceTest
  puts "  #{klass.name}:"
  puts "    定数: #{klass.constants.sort}"
  
  # sub_test_case は定数として定義される
  klass.constants.each do |const_name|
    const = klass.const_get(const_name)
    if const.is_a?(Class) && const < Test::Unit::TestCase
      puts "    #{const.name}:"
      puts "      public_instance_methods(false): #{const.public_instance_methods(false).grep(/^test_/)}"
    end
  end
end
