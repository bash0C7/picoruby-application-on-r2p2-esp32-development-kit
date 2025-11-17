# Project Status

## Current Status (Latest - 2025-11-17)

- ✅ **All Tests**: 231 tests passing (100% success rate)
- ✅ **Quality**: RuboCop clean (0 violations), coverage 86.12% line / 64.59% branch
- ✅ **ptrk init Command**: Complete with PicoRuby templates (.rubocop.yml, CLAUDE.md)
- ✅ **Mrbgemfile DSL**: Complete with template generation
- ✅ **Type System Integration**: Complete (rbs-inline + Steep)
- ✅ **Build Environment Setup**: Automatic git clone/checkout for `ptrk env latest`
- ✅ **Rake Command Polymorphism**: Smart detection for bundle exec vs rake
- ✅ **PicoRuby Development Templates**: Enhanced CLAUDE.md with mrbgems, I2C/GPIO/RMT, memory optimization

---

## Test Execution

**Quick Reference**:
```bash
bundle exec rake test         # Run all tests (231 tests)
bundle exec rake ci           # CI checks: tests + RuboCop + coverage validation
bundle exec rake dev          # Development: RuboCop auto-fix + tests + coverage
```

---

## Completed Features (v0.1.0)

### ✅ ptrk init Command
- Project initialization with templates
- Auto-generation of `.rubocop.yml` with PicoRuby configuration
- Enhanced `CLAUDE.md` with comprehensive development guide
- Template variables: {{PROJECT_NAME}}, {{AUTHOR}}, {{CREATED_AT}}, {{PICOTOROKKO_VERSION}}
- Optional `--with-ci` flag for GitHub Actions integration

### ✅ Environment Management
- `ptrk env set` — Create/update environments with git commit reference
- `ptrk env show` — Display environment details
- `ptrk env list` — List all configured environments
- `ptrk env latest` — Auto-fetch latest repo versions with git clone/checkout
- `ptrk env reset` — Reset to default configuration
- `ptrk env patch_export` — Export patches from specific environment

### ✅ Device Commands
- `ptrk device build` — Build firmware in environment
- `ptrk device flash` — Flash firmware to device
- `ptrk device monitor` — Monitor serial output
- Smart Rake command detection (bundle exec vs rake)
- R2P2-ESP32 Rakefile delegation for actual build tasks

### ✅ Infrastructure
- Executor abstraction (ProductionExecutor, MockExecutor)
- AST-based template engines (Ruby, YAML, C)
- Mrbgemfile template with picoruby-picotest reference
- Type system (rbs-inline annotations, Steep checking)

---

## Roadmap (Future Versions)

### Priority 1: Device Testing Framework
- **Status**: Research phase
- **Objective**: Enable `ptrk device {build,flash,monitor} --test` for Picotest integration
- **Estimated**: v0.2.0

### Priority 2: Additional mrbgems Management
- **Status**: Planned
- **Objective**: Commands for generating, testing, publishing mrbgems
- **Estimated**: v0.2.0+

### Priority 3: CI/CD Templates
- **Status**: Planned
- **Objective**: Enhanced GitHub Actions workflow templates
- **Estimated**: v0.3.0+

---

## Documentation Files

**For ptrk Users** (located in docs/):
- `README.md` — Installation and quick start
- `docs/CI_CD_GUIDE.md` — Continuous integration setup
- `docs/MRBGEMS_GUIDE.md` — mrbgems creation and management
- `docs/github-actions/` — Workflow templates for CI/CD

**For Gem Developers** (located in .claude/):
- `.claude/docs/` — Internal design documents
- `.claude/skills/` — Development workflow agents
- `CLAUDE.md` — Development guidelines and conventions
- `SPEC.md` — Detailed feature specification

**Auto-Generated for Projects** (via ptrk init):
- `{{PROJECT_NAME}}/CLAUDE.md` — PicoRuby development guide for the project
- `{{PROJECT_NAME}}/.rubocop.yml` — Project-specific linting configuration
- `{{PROJECT_NAME}}/README.md` — Project setup instructions
- `{{PROJECT_NAME}}/Mrbgemfile` — mrbgems dependencies

---

## Quality Gates

All features must pass:
- ✅ Tests: 100% success rate (currently 231/231)
- ✅ RuboCop: 0 violations
- ✅ Coverage: ≥85% line, ≥60% branch
- ✅ Type checking: Steep validation passing
- ✅ Documentation: Updated with code changes

---

## Recent Changes

### Session Latest: PicoRuby Development Templates (Commit 6905e71)
- Added `.rubocop.yml` template with PicoRuby-specific configuration
- Enhanced `CLAUDE.md` template with:
  - mrbgems dependency management
  - Peripheral APIs (I2C, GPIO, RMT) with examples
  - Memory optimization techniques
  - RuboCop configuration guide
  - Picotest testing framework
- Updated ProjectInitializer to copy template files
- Fixed UTF-8 encoding in tests for international characters
- All tests passing: 231/231, coverage stable

### Previous Sessions: Environment & Build Features
- Session 6: Fixed `ptrk env latest` infrastructure issues
  - Resolved fetch_latest_repos Thor warning
  - Fixed invalid `git clone --branch HEAD` syntax
  - Updated error messages (pra → ptrk)
- Session 5: Implemented build environment setup and Gemfile detection
  - Automatic git clone/checkout for repositories
  - Smart Rake command detection (bundle exec vs rake)
  - Improved error handling and logging

---

## Known Limitations & Future Work

1. **Device Testing**: Picotest integration not yet implemented (`--test` flag for device commands)
2. **C Linting**: No C linting tools currently in templates (could add clang-format in v0.2.0)
3. **Cache Management**: Not implemented (considered for v0.2.0+)
4. **mrbgems Generation**: Basic support only; full workflow in v0.2.0

---

## Installation & Release

### For End Users
```bash
gem install picotorokko
```

### For Development
```bash
git clone https://github.com/bash0C7/picotorokko
cd picotorokko
bundle install
bundle exec rake test
```

Current version: **0.1.0** (released to RubyGems)

---

## 🐛 [TODO-CODE-QUALITY-ISSUES] Found During Coverage Analysis (Session Latest)

### ProjectInitializer Issues (lib/picotorokko/project_initializer.rb)

1. **[ISSUE-1] detect_git_author returns empty string instead of nil**
   - Location: line 126-131
   - Problem: `git config user.name` returns empty string when not set, but `.strip` doesn't convert to nil
   - Impact: `prepare_variables` (line 112) treats empty string as valid author, shows empty field in templates
   - Test gap: No test for missing git user.name (only test with partial config exists)
   - Severity: Low (cosmetic, doesn't break initialization)

2. **[ISSUE-2] validate_project_name! rejects valid mixed-case names**
   - Location: line 88 `\A[a-zA-Z0-9_-]+\z`
   - Problem: Regex allows UPPERCASE letters but convention expects lowercase+dashes
   - Example: "TestProject" is accepted but "test-project" is recommended
   - Test gap: Tests added for uppercase rejection, but spec doesn't clarify intent
   - Severity: Low (follows project conventions, but documentation mismatch)

3. **[ISSUE-3] render_template silently skips missing templates**
   - Location: line 157-160
   - Problem: When template file doesn't exist, just prints warning and returns without error
   - Impact: Project created with incomplete files (missing .gitignore, README.md, etc.)
   - Test gap: No test for missing template file scenario
   - Severity: High (silent data loss, hard to debug)

4. **[ISSUE-4] with_ci option checking is overly complex**
   - Location: line 186
   - Problem: Checks 4 different keys (`:with_ci`, `"with_ci"`, `:"with-ci"`, `"with-ci"`)
   - Question: Why? Thor should normalize this to one form. Indicates unclear option handling.
   - Test gap: Only tests default case, not --with-ci explicitly
   - Severity: Medium (works but maintainability issue)

5. **[ISSUE-5] No error handling for template rendering failures**
   - Location: line 163 `Picotorokko::Template::Engine.render()`
   - Problem: If template engine throws exception (invalid syntax, etc), whole init fails
   - Example: Bad ERB syntax in template causes silent crash
   - Test gap: No test for render engine failure
   - Severity: High (can brick initialization)

### Env.rb Issues (lib/picotorokko/commands/env.rb)

6. **[ISSUE-6] fetch_repo_info doesn't handle git command failures**
   - Location: line 482-484
   - Problem: `git rev-parse` and `git show` failures not checked, just uses empty/malformed strings
   - Impact: If Git command fails, timestamp parsing at line 484 may crash with ArgumentError
   - Test gap: No test for git command failure scenario
   - Severity: High (can crash ptrk env latest)

7. **[ISSUE-7] clone_and_checkout_repo ignores system() return value**
   - Location: line 520, 523
   - Problem: `system()` returns false on failure, but code doesn't check exit status
   - Impact: If clone fails (network error, permission denied), silently continues
   - Result: Partial clone remains, next run skips due to line 517 "already exists" check
   - Test gap: No test for git clone failure
   - Severity: High (corrupts environment state, hard to recover)

8. **[ISSUE-8] Partially cloned repos cause infinite loop**
   - Location: line 517 `return if Dir.exist?(target_path)`
   - Problem: If clone fails but directory was created, subsequent runs skip it
   - Impact: User sees "already cloned" message but no actual content
   - Workaround: Manual `rm -rf ptrk_env/...` needed
   - Test gap: No test for partial clone recovery
   - Severity: High (UX nightmare)

9. **[ISSUE-9] setup_build_environment has no atomic transaction**
   - Location: line 497-508
   - Problem: If repo N fails during setup_build_environment, repos 1..N-1 are left cloned
   - Impact: Inconsistent state - partial environment created
   - Test gap: No test for mid-way failure during setup
   - Severity: High (rollback not implemented)

10. **[ISSUE-10] Error output suppressed (2>/dev/null) makes debugging hard**
    - Location: line 475, 520, 523
    - Problem: All git errors are silently discarded, only exit codes visible
    - Impact: User can't see actual error (network timeout vs auth failure vs disk full)
    - Workaround: None - have to strace or add debug output
    - Severity: Medium (operational issue)

### Device.rb Issues (lib/picotorokko/commands/device.rb)

11. **[ISSUE-11] parse_env_from_args treats empty --env= as valid**
    - Location: line 174 `arg.split("=", 2)[1]`
    - Problem: `--env=` returns empty string "", not nil (should reject)
    - Impact: `ptrk device build --env=` silently uses empty env name
    - Test gap: No test for `--env=` edge case
    - Severity: Medium (invalid input accepted, cryptic error later)

12. **[ISSUE-12] build_rake_command vulnerable to empty task_name**
    - Location: line 354
    - Problem: If `task_name` is empty string, generates `rake ` which is invalid
    - Impact: Calling build_rake_command with empty task fails with cryptic rake error
    - Test gap: No test for empty task_name
    - Severity: Low (internal use only, but bad defensive programming)

13. **[ISSUE-13] No validation of Gemfile existence before bundle exec**
    - Location: line 353 `File.exist?(gemfile_path)`
    - Problem: Checks existence but what if Gemfile is corrupted/unreadable?
    - Impact: `bundle exec rake` may fail with unclear "Gemfile not found" error
    - Test gap: No test for corrupted Gemfile case
    - Severity: Low (rare, user would need to investigate bundle)

### Testing/Coverage Gaps Summary

**Need to add tests for**:
- ✅ ProjectInitializer: Missing template file handling, template engine failure
- ✅ Env.rb: Git command failures (clone, checkout, rev-parse, show), partial clone recovery
- ✅ Device.rb: Empty task_name, empty --env= value
- ✅ Error paths: No rollback/cleanup for partially failed operations
- ✅ Integration: Full ptrk init → ptrk env latest → ptrk device build flow with failures at each step

**Impact on Coverage**:
- Current: 86.12% line / 64.59% branch
- Missing: Most error paths and edge case branches
- Estimated to add: 10-15 tests to reach 90%+ coverage

---

## 📊 [TODO-LARGE-METHOD-COVERAGE-GAPS] Other Untested Code Outside Session Scope

### Env.rb Module (lib/picotorokko/env.rb) - 364 lines

**CRITICAL - Zero Test Coverage:**

14. **[ISSUE-14] traverse_submodules_and_validate - 37 lines, COMPLETELY UNTESTED**
    - Location: line 229-265
    - Complexity: 3-level nested submodule traversal with depth tracking
    - Error paths not tested:
      - `git config submodule.*.path` failures
      - Missing submodule commits
      - Deep submodule warnings (depth > 2)
      - Git command timeouts
    - Impact: Users won't know if their R2P2-ESP32 clone is incomplete
    - Test gap: 0 tests for this 37-line method
    - Severity: CRITICAL (core functionality untested)

15. **[ISSUE-15] Untested path/cache infrastructure methods**
    - Methods not tested: `validate_env_name!`, `clone_with_submodules`, `get_commit_hash`, `get_timestamp`
    - Problem: Core directory structure methods have no test coverage
    - Impact: Silent failures if paths are malformed
    - Test gap: ~8 methods untested
    - Severity: HIGH (silent data loss potential)

### BuildConfigApplier (lib/picotorokko/build_config_applier.rb) - 158 lines

16. **[ISSUE-16] Invalid Ruby syntax not handled**
    - Location: line 23 (rescue clause at end of render)
    - Problem: If config file has syntax errors, silently returns unchanged
    - Impact: User doesn't know their mrbgem config wasn't applied
    - Test gap: No test for invalid Ruby in config
    - Severity: HIGH (silent failure)

17. **[ISSUE-17] Block depth tracking fails with mixed do...end/{...}**
    - Location: line 74-83 (find_build_block_end_line)
    - Problem: Depth counting assumes consistent block syntax, can fail with:
      - `do...end` and `{...}` on same line
      - Lambdas/procs mixing with build block
    - Impact: Incorrect line detection, mrbgem config inserted in wrong place
    - Test gap: No test for mixed block syntax
    - Severity: HIGH (data corruption possible)

### Commands/Mrbgems (lib/picotorokko/commands/mrbgems.rb) - 103 lines

18. **[ISSUE-18] No fallback when git config user.name missing**
    - Location: line 46
    - Problem: Uses `git config user.name` with no error handling
    - Impact: If git not configured, crashes with empty author
    - Test gap: No test for missing git config
    - Severity: MEDIUM (rare, but breaks on fresh git setups)

19. **[ISSUE-19] No validation for mrbgems directory already existing as file**
    - Location: line 53
    - Problem: Creates directory without checking if path is already a file
    - Impact: `mkdir_p` fails cryptically if `mrbgems/` exists as file not dir
    - Test gap: No test for this edge case
    - Severity: MEDIUM (UX issue)

### Template/RubyEngine (lib/picotorokko/template/ruby_engine.rb) - 105 lines

20. **[ISSUE-20] Placeholder mapping doesn't handle underscores correctly**
    - Location: line 87 (constant_name.downcase)
    - Problem: `TEMPLATE_CLASS_NAME_APP` becomes `class_name_app` but expects `classNameApp` or different format
    - Impact: Placeholders with underscores don't match variables
    - Test gap: No test for underscore handling
    - Severity: MEDIUM (template variable naming broken)

21. **[ISSUE-21] Multiple identical placeholders on same line not handled**
    - Location: line 116-124 (apply_replacements)
    - Problem: Simple string replacement doesn't account for offset shifts
    - Impact: If same placeholder appears twice on line, second replacement is offset
    - Test gap: No test for duplicate placeholders
    - Severity: MEDIUM (template rendering broken for DRY code)

### Summary by Priority

**CRITICAL (implement immediately)**:
- ISSUE-14: `traverse_submodules_and_validate` - 37 lines, 0 tests
- ISSUE-16: Invalid Ruby syntax handling
- ISSUE-17: Block depth tracking with mixed syntax

**HIGH** (implement soon):
- ISSUE-15: Path/cache methods untested
- ISSUE-18: Git config fallback missing
- ISSUE-20: Placeholder underscore mapping broken

**MEDIUM** (implement next):
- ISSUE-19: mrbgems directory validation
- ISSUE-21: Duplicate placeholder handling

### Overall Test Coverage Status

| File | Lines | Public Methods | Tested | Untested | Gap % |
|------|-------|---|---|---|---|
| env.rb | 364 | 28 | 16 | 12 | 43% |
| build_config_applier.rb | 158 | 2 | 2 | 0 (edge cases) | 15% |
| commands/rubocop.rb | 126 | 2 | 2 | 0 (I/O errors) | 5% |
| commands/mrbgems.rb | 103 | 1 | 1 | 0 (edge cases) | 10% |
| template/ruby_engine.rb | 105 | 2 | 2 | 0 (edge cases) | 10% |
| **TOTAL** | **3196** | **N/A** | **High-level** | **Low-level** | **~25-30%** |

**Estimated additional tests needed**: 30-40 tests to reach 95%+ coverage across all modules
