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

- [x] **Completed Phase 1: Migrate 3 files to block-based temp file creation**
  - [x] `test/commands/rubocop_test.rb` - 11 tests refactored
  - [x] `test/commands/build_test.rb` - 9 tests refactored
  - [x] `test/commands/mrbgems_test.rb` - 10 tests refactored
  - [x] Updated `.rubocop.yml`: Excluded test files from BlockLength metric (needed for nested blocks)
  - **Pattern Used**: `Dir.mktmpdir` with block for directory structures (Ruby standard pattern)

- [x] **Completed Phase 2: Migrate remaining 5 test files to block-based temp file creation**
  - [x] `test/commands/device_test.rb` - 11 tests refactored (with 5 sub-test groups)
  - [x] `test/commands/ci_test.rb` - 4 tests refactored
  - [x] `test/commands/patch_test.rb` - 6 tests refactored
  - [x] `test/commands/cache_test.rb` - 9 tests refactored
  - [x] `test/commands/env_test.rb` - 10 tests refactored
  - [x] Removed unnecessary File.exist? and Dir.exist? checks before rm_f/rm_rf (RuboCop: NonAtomicFileOperation)
  - [x] Updated `.rubocop.yml`: Excluded test files from ClassLength metric (for comprehensive test classes)
  - **Total refactored**: 40 test methods across 8 files
  - **Pattern**: Direct `Dir.mktmpdir { ... }` block (Ruby standard pattern)
  - **Benefit**: Automatic cleanup on block exit, better test isolation, exception safety

- **Design Decision**: Chose direct `Dir.mktmpdir { ... }` pattern over helper method
  - Pro: Standard Ruby knowledge, no project-specific complexity
  - Con: Repeat pattern in each test (~6 lines per test)
  - Rationale: Simplicity > DRY when readability is maintained
  - Result: More discoverable for new developers (well-known Ruby pattern)

- [x] **Quality gates passed (all refactoring complete)**
  - ✅ All 40 tests pass (100%) - Phase 3 adds 2 new test cases
  - ✅ RuboCop: 0 offenses (no Lint/NonAtomicFileOperation, Metrics/BlockLength, Metrics/ClassLength)
  - ✅ Test coverage improved: 65.03% line, 34.45% branch

---

## 🟡 Medium Priority (Code Quality & Documentation)

### Test Coverage Improvement

- [ ] **Expand test coverage to reach 75%+ line coverage, 50%+ branch coverage**
  - **Current metrics** (as of Phase 3):
    - Line coverage: 65.03% (504/775 lines)
    - Branch coverage: 34.45% (82/238 branches)
    - Gap: 9.97% line, 15.55% branch to reach targets
  - **Target**: 75% line, 50% branch (industry best practices for gem libraries)
  - **Phase 3 Progress**: Added tests for build clean, ci setup
    - Focus areas: error handling paths, conditional branch coverage
    - Added test cases targeting previously untested code paths
  - **Remaining Strategy**: Identify coverage gaps in:
    - Error handling paths (exception cases) - especially in device.rb, patch.rb
    - Edge cases in command implementations
    - Conditional branches not yet tested (method_missing, resolve_env_name)
    - Integration between commands
  - **Tools**: Use `bundle exec rake ci` to measure coverage before/after improvements
  - **Note**: Even with current 65.03% coverage, significant improvements possible by targeting branch coverage
  - **Recommended Next Steps**:
    1. Focus on env.rb, patch.rb, rubocop.rb error paths (currently 0% branch coverage)
    2. Add error case tests for missing caches, invalid configurations
    3. Test method delegation in device.rb (method_missing paths)
    4. Add integration tests combining multiple commands

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
