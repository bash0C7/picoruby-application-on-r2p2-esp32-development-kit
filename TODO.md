# TODO: Project Maintenance Tasks

## High Priority

- [ ] `pap env latest` の完全実装 (lib/pap/commands/env.rb:71)
  - GitHub API または `git ls-remote` で最新コミット取得
  - 自動的に .picoruby-env.yml に追記
  - キャッシュ取得と環境構築を一度に実行
  - ユニットテストの追加

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
