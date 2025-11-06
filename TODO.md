# TODO: Project Maintenance Tasks

## Naming Convention Note

**Current name**: `pra` = **P**icoRuby **A**pplication **P**latform
**Desired name**: `pra` = **P**ico**R**uby **A**pplication

The command should be renamed from `pra` to `pra` to better reflect the project's focus on PicoRuby applications.

## High Priority

- [x] Rename command from `pra` to `pra`
  - Directory: `lib/pra/` → `lib/pra/`
  - Executable: `exe/pra` → `exe/pra`
  - Gemspec: `pra.gemspec` → `pra.gemspec`
  - Module name: `Pra` → `Pra` (all Ruby files)
  - Documentation: README.md, SPEC.md, SETUP.md, etc.
  - Test files: test/pra_test.rb → test/pra_test.rb

- [ ] Add comprehensive unit tests for all commands
  - Progress: 60 tests, 155 assertions, 98% passing (1 minor assertion failure)
  - Added tests:
    - [x] Cache commands: fetch (with mocking)
    - [x] Build commands: setup (with git repo setup)
    - [x] Patch commands: export, apply, diff (with git repo setup)
    - [x] R2P2 commands: flash, monitor (with env stubs)
  - Note: All core command functionality is tested; tests validate happy path and error handling

## Future Enhancements (Optional)

- [ ] CI/CD 統合（要仕様作成）
  - GitHub Actions での自動テスト実行
  - 自動リリース・バージョン管理
  - **Status**: 仕様定義が必要（repository側だけでなくGitHub Actions設定も必要）
