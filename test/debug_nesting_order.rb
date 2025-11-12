#!/usr/bin/env ruby
# frozen_string_literal: true

# ネスト順序の問題を調査

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "=" * 80
puts "Testing nesting order: with_fresh_project_root + Dir.mktmpdir"
puts "=" * 80

class NestingTest < PraTestCase
  include SystemCommandMocking
  
  test "demonstrates the nesting problem" do
    puts "\n[TEST START]"
    puts "  Initial Dir.pwd: #{Dir.pwd}"
    
    with_fresh_project_root do
      puts "  [with_fresh_project_root] entered"
      puts "    Dir.pwd: #{Dir.pwd}"
      
      Dir.mktmpdir do |tmpdir|
        puts "  [Dir.mktmpdir] entered"
        puts "    tmpdir: #{tmpdir}"
        puts "    Dir.pwd (before chdir): #{Dir.pwd}"
        
        Dir.chdir(tmpdir)
        puts "    Dir.pwd (after chdir): #{Dir.pwd}"
        
        # Simulate test work
        puts "    [doing test work...]"
        
        puts "  [Dir.mktmpdir] about to exit"
        puts "    Dir.pwd: #{Dir.pwd}"
      end
      
      # THIS IS THE PROBLEM POINT:
      # After Dir.mktmpdir exits, tmpdir is deleted
      # But Dir.pwd might still point to the deleted tmpdir
      
      begin
        current = Dir.pwd
        puts "  [AFTER mktmpdir] Dir.pwd: #{current}"
        puts "    Dir.exist?(pwd): #{Dir.exist?(current)}"
      rescue Errno::ENOENT => e
        puts "  [AFTER mktmpdir] ERROR: #{e.message}"
        puts "    Dir.pwd is pointing to deleted tmpdir!"
      end
      
      puts "  [with_fresh_project_root] about to exit (ensure will run)"
    end
    
    puts "  [AFTER with_fresh_project_root] Dir.pwd: #{Dir.pwd}"
    puts "[TEST END]"
  end
end

exit Test::Unit::AutoRunner.run
