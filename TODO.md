# TODO: Project Maintenance Tasks

> **TODO Management Methodology**: See `.claude/skills/project-workflow/SKILL.md` and `CLAUDE.md` ## TODO Management section for task management rules and workflow.

---

## 🔮 Future Enhancements (Phase 5+)

For detailed implementation guide and architecture design of the PicoRuby RuboCop Custom Cop, see [docs/RUBOCOP_PICORUBY_GUIDE.md](docs/RUBOCOP_PICORUBY_GUIDE.md).

---

## 🔴 技術的負債（Technical Debt）

### CI テスト除外（device_test.rb）

**負債内容**: Phase 3 で `device_test.rb` を CI から除外（`TEST_EXCLUDE=test/commands/device_test.rb`）

- **根本原因**: `device_test.rb` が R2P2-ESP32 Rake タスク呼び出しに依存
  - テスト内で `execute_with_esp_env` をスタブ化しているが、完全な依存排除ができていない
  - CI 環境では ESP-IDF 不在のため、本来は実行不可

- **現在の対応**: テストレイヤー分離（アプローチ B）
  - ローカル開発: 全 38 tests 実行可能（統合テスト検証）
  - CI: 66 tests 実行（device_test.rb 除外）

- **将来の改善案** (推奨):
  1. **アプローチ A（推奨）**: `lib/pra/env.rb` に CI 環境検出を追加
     ```ruby
     def execute_with_esp_env(command, working_dir)
       return system(command, chdir: working_dir) if ENV["CI"]  # CI では skip
       # ESP-IDF setup...
     end
     ```
     - メリット: シンプル、全テストを CI で実行可能
     - 実装: 1 行追加のみ

  2. **代替案**: device_test.rb を完全モック化
     - R2P2-ESP32 Rakefile 依存を Mock オブジェクトで完全置換
     - 複雑度は高いが、テスト独立性が向上

- **削除予定**: アプローチ A 実装後、`TEST_EXCLUDE` は不要

### テストのモック・スタブ処理

**負債内容**: device_test.rb で `execute_with_esp_env` をメソッド再定義でスタブ化

- **ファイル**: `test/commands/device_test.rb:379-420`（4 個のヘルパーメソッド）
  - `with_stubbed_esp_env`
  - `with_failing_esp_env`
  - `with_tasks_list_esp_env`
  - `setup_test_environment`, `setup_test_environment_with_current`

- **対応方針**:
  - 現状のテスト実装は有効（重複コード削減）
  - アプローチ A 実装後も、ローカルテストのモック化は保持可能
  - CI では `execute_with_esp_env` が自動的に skip される

---

## Future Enhancements (Optional)

### CLI Command Structure Refactoring

- [ ] Consider renaming commands in future if needed (e.g., `pra build-env` or `pra workspace`)

---

### ⚠️ pra ci: --force Option (Implementation Forbidden)

**Status**: `pra ci setup` already implemented. The `--force` option is **forbidden** unless explicitly requested.

- 🚫 **Do not implement** `pra ci setup --force` option
  - **Current behavior**: Interactive prompt "Overwrite? (y/N)" if file exists
  - **Reason forbidden**: CI templates follow "fork and customize" model; users should own and edit templates directly
  - **Permitted**: Modify CI templates and documentation in `docs/`

---

## 🔧 Code Quality Improvements

### Refactor Test Temporary File Handling

- [ ] **Migrate tests from setup/teardown to block-based temp file creation**
  - **Files**: `test/commands/rubocop_test.rb`, `build_test.rb`, `mrbgems_test.rb`
  - **Pattern A (preferred)**: Use `Tempfile.open` with block for file operations
  - **Pattern B (when needed)**: Use `Dir.mktmpdir` with block for directory structures
  - **Security Benefits**: Prevent symlink attacks (per IPA security guidelines)
  - **Safety Guarantee**: Guaranteed cleanup on block exit (even on exceptions)
  - **References**:
    - https://docs.ruby-lang.org/ja/latest/class/Tempfile.html
    - https://docs.ruby-lang.org/ja/latest/method/Dir/s/mktmpdir.html
    - https://magazine.rubyist.net/articles/0029/0029-BundledLibraries.html
  - **Note**: Separate session task (quality improvement, not urgent)

---

## 🟡 Medium Priority (Code Quality & Documentation)

---

## 🔒 Security Enhancements (Do not implement without explicit request)

All security enhancements below do not change behavior and should only be implemented with explicit user request.

### Symbolic Link Race Condition Prevention

- [ ] Add race condition protection to symbolic link checks
  - **Where**: Symbolic link validation in `lib/pra/commands/build.rb`
  - **Problem**: TOCTOU (Time-of-check to time-of-use) vulnerability between check and usage
  - **Solution**: Use File.stat with follow_symlinks: false instead of File.symlink?
  - **Note**: Limited real-world risk, low priority

### Path Traversal Input Validation

- [ ] Add path traversal validation for user inputs (env_name, etc.)
  - **Where**: All command files in `lib/pra/commands/`
  - **Problem**: User inputs like env_name could contain `../../` without validation
  - **Checks needed**:
    - Reject paths containing `..`
    - Reject absolute paths
    - Allow only alphanumeric, hyphen, underscore
  - **Solution**: Create `lib/pra/validator.rb` for centralized validation
  - **Testing**: Add path traversal attack test cases
  - **Note**: Current codebase is developer-facing tool with limited attack surface
