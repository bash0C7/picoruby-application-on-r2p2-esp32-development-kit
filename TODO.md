# TODO: Project Maintenance Tasks

> **TODO Management Methodology**: See `.claude/skills/project-workflow/SKILL.md` and `CLAUDE.md` ## TODO Management section for task management rules and workflow.

---

## 🔮 Future Enhancements (Phase 5+)

For detailed implementation guide and architecture design of the PicoRuby RuboCop Custom Cop, see [docs/RUBOCOP_PICORUBY_GUIDE.md](docs/RUBOCOP_PICORUBY_GUIDE.md).

---

## 🔴 技術的負債（Technical Debt）

---

## Future Enhancements (Optional)

### CLI Command Structure Refactoring

- [ ] Consider renaming commands in future if needed (e.g., `pra build-env` or `pra workspace`)

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
