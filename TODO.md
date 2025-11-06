# TODO: Project Maintenance Tasks

## Naming Convention Note

**Current name**: `pap` = **P**icoRuby **A**pplication **P**latform
**Desired name**: `pra` = **P**ico**R**uby **A**pplication

The command should be renamed from `pap` to `pra` to better reflect the project's focus on PicoRuby applications.

## High Priority

- [ ] Rename command from `pap` to `pra`
  - Directory: `lib/pap/` → `lib/pra/`
  - Executable: `exe/pap` → `exe/pra`
  - Gemspec: `pap.gemspec` → `pra.gemspec`
  - Module name: `Pap` → `Pra` (all Ruby files)
  - Documentation: README.md, SPEC.md, SETUP.md, etc.
  - Test files: test/pap_test.rb → test/pra_test.rb

- [x] `pap env latest` の実装 (lib/pap/commands/env.rb:71)
  - ✓ GitHub API または `git ls-remote` で最新コミット取得
  - ✓ 自動的に .picoruby-env.yml に追記
  - Note: キャッシュ取得は別コマンドとして実装済み
  - TODO: ユニットテストの追加

## Documentation

- [ ] SPEC.md に変更履歴セクション追加
  - Recent changes セクションを追加
  - バージョン管理とリリースノートの記載

## Future Enhancements (Optional)

- [ ] キャッシュ圧縮機能
  - `tar.gz` で`.cache/`を圧縮
  - S3/Cloud ストレージへのバックアップ

- [ ] CI/CD 統合
  - GitHub Actions でキャッシュの自動更新
  - 自動テストとリリース
