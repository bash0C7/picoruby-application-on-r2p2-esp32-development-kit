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

## 🚀 Phase 4: Advanced Coverage (LINE 90%, BRANCH 70%)

**Objective**: Achieve industry-leading test coverage standards
**Timeline**: Incremental, lower priority than Phase 3
**Strategy**: Focus on branch coverage gaps using systematic approach

### Phase 4a: Error Handling Coverage (env.rb, patch.rb, rubocop.rb)

Priority files with 0% branch coverage identified in Phase 3:

- [ ] **env.rb: Expand from 15.49% → 75%+ line coverage**
  - [ ] `show` command: Test when env not in config (error path)
  - [ ] `show` command: Test symlink resolution and display
  - [ ] `set` command: Test when build dir doesn't exist (error path)
  - [ ] `set` command: Test successful env switching
  - [ ] `latest` command: Test network failure handling
  - [ ] `latest` command: Test git clone failure (error path)
  - [ ] `latest` command: Test successful environment creation
  - **Estimated tests**: 8-10 new test cases
  - **Expected impact**: +15-20% line, +40-50% branch

- [ ] **patch.rb: Expand from 10.71% → 75%+ line coverage**
  - [ ] `export` command: Test with changes present
  - [ ] `export` command: Test error when no current env
  - [ ] `export` command: Test when build not found (error path)
  - [ ] `apply` command: Test with patches to apply
  - [ ] `apply` command: Test when no patches exist
  - [ ] `apply` command: Test error when no current env
  - [ ] `diff` command: Test patch diff display
  - [ ] `diff` command: Test error when no current env
  - **Estimated tests**: 10-12 new test cases
  - **Expected impact**: +15-20% line, +50-70% branch

- [ ] **rubocop.rb: Expand from 25% → 75%+ line coverage**
  - [ ] `setup` command: Test successful template copy
  - [ ] `setup` command: Test overwrite prompt (yes/no responses)
  - [ ] `setup` command: Test directory copy operations
  - [ ] `update` command: Test script execution success
  - [ ] `update` command: Test script execution failure (error path)
  - [ ] `update` command: Test when script doesn't exist (error path)
  - [ ] `copy_template_files`: Test file vs directory handling
  - [ ] `copy_template_files`: Test when target exists (overwrite)
  - **Estimated tests**: 8-10 new test cases
  - **Expected impact**: +20-30% line, +60-80% branch

### Phase 4b: Build Command Branch Coverage (89.12% → 95%+)

Remaining gaps in high-value command:

- [ ] **build.rb cache validation tests**
  - [ ] Test R2P2-ESP32 cache missing (true branch: line 44)
  - [ ] Test picoruby-esp32 cache missing (true branch: line 47)
  - [ ] Test picoruby cache missing (true branch: line 50)
  - [ ] Test setup with explicit env_name (false branch: line 18)
  - [ ] Test setup when current symlink resolved (true branch: line 20)
  - **Estimated tests**: 5 new test cases
  - **Expected impact**: +2-3% line, +15-20% branch

- [ ] **build.rb patch generation tests**
  - [ ] Test when build_config patch already has App (line 214)
  - [ ] Test when CMakeLists.txt already has App (line 234)
  - [ ] Test when storage/home doesn't exist (line 99 conditional)
  - [ ] Test rake setup_esp32 failure handling (rescue: line 87)
  - **Estimated tests**: 4 new test cases
  - **Expected impact**: +1-2% line, +10-15% branch

### Phase 4c: Device Command Delegation (94.12% → 98%+)

Test method_missing and resolve_env_name edge cases:

- [ ] **device.rb method delegation**
  - [ ] Test undefined Rake task raises Thor error
  - [ ] Test method_missing with underscore prefix (calls super)
  - [ ] Test method_missing with valid Rake task delegation
  - [ ] Test tasks command list output
  - [ ] Test help command is properly handled
  - **Estimated tests**: 5 new test cases
  - **Expected impact**: +2-3% line, +12-18% branch

- [ ] **device.rb error handling**
  - [ ] Test resolve_env_name with no current symlink (error path)
  - [ ] Test validate_and_get_r2p2_path with missing config (error path)
  - [ ] Test validate_and_get_r2p2_path with missing build (error path)
  - **Estimated tests**: 3 new test cases
  - **Expected impact**: +1-2% line, +8-12% branch

### Phase 4d: Integration Tests

Tests combining multiple commands:

- [ ] **env → build → device workflow**
  - [ ] Create env → setup build → flash device (happy path)
  - [ ] Create env → fail setup → error message
  - [ ] Switch env → verify symlink updated

- [ ] **build → patch → build workflow**
  - [ ] Setup build → modify files → export patches → re-setup
  - [ ] Patch apply after setup
  - [ ] Patch diff shows changes

- [ ] **cache → build → mrbgems workflow**
  - [ ] Fetch cache → setup build → generate mrbgem
  - [ ] Verify environment ready for development

- [ ] **ci → rubocop workflow**
  - [ ] Setup CI → setup RuboCop → both configured
  - [ ] Update RuboCop methods database

### Phase 4 Coverage Target Table

| Current State | Target | Gap | Priority |
|---|---|---|---|
| Line: 65.03% | 90% | 24.97% | Medium |
| Branch: 34.45% | 70% | 35.55% | High |
| env.rb: 15.49% → 75% | 60% gap | Highest |
| patch.rb: 10.71% → 75% | 64% gap | Highest |
| rubocop.rb: 25% → 75% | 50% gap | High |
| build.rb: 89.12% → 95% | 6% gap | Medium |
| device.rb: 94.12% → 98% | 4% gap | Medium |

### Phase 4 Implementation Strategy

1. **Week 1**: env.rb + patch.rb coverage (highest impact)
   - Expected: LINE +30%, BRANCH +45%

2. **Week 2**: rubocop.rb + build.rb improvements
   - Expected: LINE +15%, BRANCH +15%

3. **Week 3**: device.rb + remaining gaps
   - Expected: LINE +3%, BRANCH +8%

4. **Week 4**: Integration tests
   - Expected: Final polish to reach 85%+ LINE, 65%+ BRANCH

**Final Target**: LINE 88-92%, BRANCH 68-72% (achievable with focused effort)

**Tools**: Use `.claude/docs/testing-guidelines.md` "Coverage Improvement Strategy" section for implementation guidance

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
