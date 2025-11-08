# frozen_string_literal: true

require "thor"
require "fileutils"
require "erb"

module Pra
  module Commands
    # Application-specific mrbgem管理コマンド群
    class Mrbgems < Thor
      def self.exit_on_failure?
        true
      end

      desc "generate [NAME]", "Generate application-specific mrbgem template (default: App)"
      option :author, type: :string, desc: "Author name for the mrbgem"
      def generate(name = "App")
        # テンプレート変数の準備
        mrbgem_name = name
        class_name = name
        c_prefix = name.downcase
        author_name = options[:author] || `git config user.name`.strip || "Your Name"

        # mrbgemディレクトリを作成
        mrbgem_dir = File.join(Dir.pwd, "mrbgems", mrbgem_name)

        raise "Error: Directory already exists: #{mrbgem_dir}" if Dir.exist?(mrbgem_dir)

        puts "Generating mrbgem template: #{mrbgem_name}"

        # ディレクトリ構造を作成
        FileUtils.mkdir_p(File.join(mrbgem_dir, "mrblib"))
        FileUtils.mkdir_p(File.join(mrbgem_dir, "src"))
        puts "✓ Created directories"

        # テンプレート変数をバインディングに設定
        template_context = Object.new
        template_context.define_singleton_method(:mrbgem_name) { mrbgem_name }
        template_context.define_singleton_method(:class_name) { class_name }
        template_context.define_singleton_method(:c_prefix) { c_prefix }
        template_context.define_singleton_method(:author_name) { author_name }

        # テンプレートファイルのパス
        gem_root = File.expand_path("../../../", __dir__)
        templates_dir = File.join(gem_root, "lib", "pra", "templates", "mrbgem_app")

        # 各テンプレートファイルをレンダリング
        template_files = {
          "mrbgem.rake.erb" => File.join(mrbgem_dir, "mrbgem.rake"),
          "mrblib/app.rb.erb" => File.join(mrbgem_dir, "mrblib", "#{c_prefix}.rb"),
          "src/app.c.erb" => File.join(mrbgem_dir, "src", "#{c_prefix}.c"),
          "README.md.erb" => File.join(mrbgem_dir, "README.md")
        }

        template_files.each do |template_rel_path, output_path|
          template_path = File.join(templates_dir, template_rel_path)

          raise "Error: Template file not found: #{template_path}" unless File.exist?(template_path)

          # ERBテンプレートをレンダリング
          template_content = File.read(template_path)
          erb = ERB.new(template_content, trim_mode: "-")
          rendered_content = erb.result(template_context.instance_eval { binding })

          # ファイルに書き込み
          File.write(output_path, rendered_content)
          puts "✓ Created: #{File.basename(output_path)}"
        end

        puts "\n=== mrbgem Template Generated ==="
        puts "Location: mrbgems/#{mrbgem_name}/"
        puts "\nNext steps:"
        puts "  1. Edit the C extension: mrbgems/#{mrbgem_name}/src/#{c_prefix}.c"
        puts "  2. The mrbgem will be registered automatically during 'pra build setup'"
        puts "  3. Export patches to manage your changes: pra patch export <env>"
      end
    end
  end
end
