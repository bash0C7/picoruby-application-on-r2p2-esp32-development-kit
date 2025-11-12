#!/usr/bin/env ruby
# frozen_string_literal: true

# クリーンアップの問題を調査

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
$LOAD_PATH.unshift File.expand_path("..", __dir__)
$LOAD_PATH.unshift File.expand_path(".", __dir__)
require_relative "test_helper"

puts "=" * 80
puts "Investigating cleanup issues"
puts "=" * 80

puts "\n[1] Initial state:"
puts "  Dir.pwd: #{Dir.pwd}"
puts "  ENV['PTRK_USER_ROOT']: #{ENV['PTRK_USER_ROOT']}"
puts "  Picotorokko::Env.project_root: #{Picotorokko::Env.project_root}"
puts "  Picotorokko::Env.get_build_path('test-env'): #{Picotorokko::Env.get_build_path('test-env')}"

puts "\n[2] Simulating device_test.rb behavior:"
puts "  with_fresh_project_root do"

# device_test.rb の実際の処理をシミュレート
original_dir = Dir.pwd
with_fresh_project_root_called = false

Dir.mktmpdir do |tmpdir|
  puts "    Dir.mktmpdir: #{tmpdir}"
  Dir.chdir(tmpdir)
  puts "    Dir.chdir(tmpdir) - now Dir.pwd: #{Dir.pwd}"
  
  # with_fresh_project_root が呼ばれたと仮定
  with_fresh_project_root_called = true
  
  # setup_test_environment が呼ばれる
  puts "    setup_test_environment('test-env'):"
  r2p2_info = { "commit" => "abc1234", "timestamp" => "20250101_120000" }
  esp32_info = { "commit" => "def5678", "timestamp" => "20250102_120000" }
  picoruby_info = { "commit" => "ghi9012", "timestamp" => "20250103_120000" }
  
  Picotorokko::Env.set_environment('test-env', r2p2_info, esp32_info, picoruby_info)
  
  build_path = Picotorokko::Env.get_build_path('test-env')
  puts "      build_path: #{build_path}"
  puts "      build_path starts with tmpdir? #{build_path.start_with?(tmpdir)}"
  puts "      build_path starts with original_dir? #{build_path.start_with?(original_dir)}"
  
  r2p2_path = File.join(build_path, "R2P2-ESP32")
  FileUtils.mkdir_p(r2p2_path)
  puts "      Created: #{r2p2_path}"
  puts "      Exists? #{Dir.exist?(r2p2_path)}"
end

puts "\n[3] After Dir.mktmpdir cleanup:"
puts "  Dir.pwd: #{Dir.pwd}"
puts "  tmpdir was automatically cleaned up by Ruby"

# build_path が original_dir 配下に作られていた場合、残る
build_path = Picotorokko::Env.get_build_path('test-env')
puts "\n[4] Checking if build_path still exists:"
puts "  build_path: #{build_path}"
puts "  Exists? #{Dir.exist?(build_path)}"

if Dir.exist?(build_path)
  puts "  ⚠️  WARNING: build_path was NOT cleaned up!"
  puts "  This is a LEAK - files remain after test"
end

puts "\n[5] Checking PTRK_USER_ROOT tmpdir:"
ptrk_root = ENV['PTRK_USER_ROOT']
if ptrk_root && Dir.exist?(ptrk_root)
  entries = Dir.entries(ptrk_root).reject { |e| e == '.' || e == '..' }
  puts "  PTRK_USER_ROOT: #{ptrk_root}"
  puts "  Exists? YES"
  puts "  Entries: #{entries.size} items"
  if entries.size > 0
    puts "  ⚠️  WARNING: PTRK_USER_ROOT has accumulated files!"
    puts "  Contents: #{entries[0..5].join(', ')}#{entries.size > 5 ? '...' : ''}"
  end
else
  puts "  PTRK_USER_ROOT: Does not exist (cleaned up)"
end
