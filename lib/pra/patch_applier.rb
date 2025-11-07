# frozen_string_literal: true

require 'fileutils'

module Pra
  # パッチ適用の共通ロジック
  module PatchApplier
    # パッチを適用
    #
    # @param build_path [String] ビルドパス（通常は build/<env_name>）
    # @param verbose [Boolean] 詳細ログ出力有無
    def apply_patches(build_path, verbose: true)
      puts '  Applying patches...' if verbose

      %w[R2P2-ESP32 picoruby-esp32 picoruby].each do |repo|
        patch_repo_dir = File.join(Pra::Env::PATCH_DIR, repo)
        next unless Dir.exist?(patch_repo_dir)

        work_path = determine_work_path(repo, build_path)
        next unless Dir.exist?(work_path)

        apply_repo_patches(patch_repo_dir, work_path, repo, verbose)
      end

      puts '  ✓ Patches applied' if verbose
    end

    private

    # リポジトリに応じた作業パス決定
    def determine_work_path(repo, build_path)
      case repo
      when 'R2P2-ESP32'
        File.join(build_path, 'R2P2-ESP32')
      when 'picoruby-esp32'
        File.join(build_path, 'R2P2-ESP32', 'components', 'picoruby-esp32')
      when 'picoruby'
        File.join(build_path, 'R2P2-ESP32', 'components', 'picoruby-esp32', 'picoruby')
      end
    end

    # リポジトリのパッチファイル適用
    def apply_repo_patches(patch_repo_dir, work_path, repo, verbose)
      Dir.glob("#{patch_repo_dir}/**/*").sort.each do |patch_file|
        next if File.directory?(patch_file)
        next if File.basename(patch_file) == '.keep'

        rel_path = patch_file.sub("#{patch_repo_dir}/", '')
        dest_file = File.join(work_path, rel_path)

        FileUtils.mkdir_p(File.dirname(dest_file))
        FileUtils.cp(patch_file, dest_file)
      end

      puts "    Applied #{repo}" if verbose
    end
  end
end
