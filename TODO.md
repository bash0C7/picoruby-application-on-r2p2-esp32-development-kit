# Project Status

## Current Status (Latest - 2025-11-19)

**🔧 IN PROGRESS: ptrk env latest Submodule Initialization Fix**
- 🔧 **Phase 1-2**: Completed investigation and SPEC.md update
- 🔧 **Phase 3a**: Partially complete - added `cache_clone_with_submodules` method
- 📋 **Updates**: SPEC.md and TODO.md revised for correct design
- 🚀 **Next**: Simplify `ptrk env latest`, implement `.build` setup in `ptrk device build`

**Completed Milestones:**
- ✅ **All Tests**: Passing (100% success rate)
- ✅ **Quality**: RuboCop clean (0 violations), coverage targets met
- ✅ **Error Handling**: All identified code quality issues verified and documented
- ✅ **ptrk init Command**: Complete with PicoRuby templates (.rubocop.yml, CLAUDE.md)
- ✅ **Mrbgemfile DSL**: Complete with template generation
- ✅ **Type System Integration**: Complete (rbs-inline + Steep)
- ✅ **Build Environment Setup**: Automatic git clone/checkout for `ptrk env latest`
- ✅ **Rake Command Polymorphism**: Smart detection for bundle exec vs rake
- ✅ **PicoRuby Development Templates**: Enhanced CLAUDE.md with mrbgems, I2C/GPIO/RMT, memory optimization

---

## Active Implementation: Fix ptrk env latest (Phase 3-4)

### ⚠️ Design Correction
**Old (SPEC.md v1 - incorrect)**:
- `ptrk cache fetch` → `ptrk build setup` → `ptrk device build`

**New (SPEC.md v2 - correct)**:
- `ptrk env latest` → save environment definition only
- `ptrk device build` → setup `.ptrk_build/` and build firmware

### Phase 3a: Directory naming consistency (ptrk_env → .ptrk_env)
- [ ] **TDD RED**: Write tests for `.ptrk_env/` directory usage
- [ ] **TDD GREEN**: Update `ENV_DIR` constant from `ptrk_env` to `.ptrk_env`
- [ ] **TDD GREEN**: Update all `get_build_path`, `get_environment`, file operations to use `.ptrk_env/`
- [ ] **TDD GREEN**: Update test fixtures and test setup
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "refactor: rename ptrk_env to .ptrk_env for consistency and visibility control"

### Phase 3: Remove env creation from ptrk new
- [ ] **TDD RED**: Write test for `ptrk new` without environment creation
- [ ] **TDD GREEN**: Remove `setup_default_environment` from ProjectInitializer
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **TDD REFACTOR**: Clean up any dead code
- [ ] **COMMIT**: "refactor: remove automatic environment creation from ptrk new"

### Phase 3b: Rename ptrk env latest to ptrk env set --latest

**Design**: Use git submodule mechanism for cross-repo consistency
- Clone R2P2-ESP32 at specified commit
- Initialize submodules and checkout picoruby-esp32 & picoruby at specified commits
- Disable push on all repos to prevent accidental pushes
- Generate env-name from local timestamp (YYYYMMDD_HHMMSS format)

#### Phase 3b-submodule: Implement submodule rewriting
- [ ] **TDD RED**: Write test for `ptrk env set --latest` with submodule rewriting
- [ ] **TDD GREEN**: Clone R2P2-ESP32 at specified commit to `.ptrk_env/{env_name}/`
- [ ] **TDD GREEN**: Extract picoruby-esp32 & picoruby commit refs from env definition
- [ ] **TDD GREEN**: Initialize submodules: `git submodule update --init --recursive`
- [ ] **TDD GREEN**: Checkout each submodule to specified commit:
  - `cd .ptrk_env/{env}/components/picoruby-esp32 && git checkout <commit>`
  - `cd picoruby && git checkout <commit>` (nested submodule)
- [ ] **TDD GREEN**: Stage submodule changes: `git add components/picoruby-esp32`
- [ ] **TDD GREEN**: Commit: `git commit --amend -m "..."` with timestamp env-name
- [ ] **TDD GREEN**: Disable push on all repos via `git remote set-url --push origin no_push`
- [ ] **TDD GREEN**: Generate env-name from local timestamp (YYYYMMDD_HHMMSS)
- [ ] **TDD GREEN**: Record R2P2-ESP32, picoruby-esp32, picoruby commit hashes in .picoruby-env.yml
- [ ] **TDD GREEN**: Auto-set current env if .picoruby-env.yml is empty/missing
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **TDD REFACTOR**: Extract git submodule operations into helper methods
- [ ] **COMMIT**: "feat: implement ptrk env set --latest with submodule rewriting"

#### Phase 3b-cleanup: Remove ptrk env latest command
- [ ] **TDD RED**: Write test verifying `ptrk env latest` is no longer available
- [ ] **TDD GREEN**: Remove `latest` command from env.rb
- [ ] **TDD GREEN**: Remove CLI registration from cli.rb
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "refactor: remove ptrk env latest command (replaced by ptrk env set --latest)"

#### Phase 3b-rubocop: Generate RuboCop config in env set

**Design**: Extract RBS files directly from env's picoruby repository
- Source: `.ptrk_env/{env}/picoruby/mrbgems/picoruby-*/sig/*.rbs`
- Parse RBS files using `rbs` gem (not markdown)
- Compare with CRuby core class methods
- Store env-specific JSON databases

- [ ] **TDD RED**: Write test for RuboCop setup during `ptrk env set --latest`
- [ ] **TDD GREEN**: Generate `.ptrk_env/{env}/rubocop/data/` directory during env creation
- [ ] **TDD GREEN**: Locate RBS files in `.ptrk_env/{env}/picoruby/mrbgems/picoruby-*/sig/*.rbs`
- [ ] **TDD GREEN**: Parse RBS using `rbs` gem and extract method definitions
- [ ] **TDD GREEN**: Extract CRuby core class methods (Array, String, Hash, Integer, Float, Symbol, Regexp, Range, Enumerable, Numeric, Kernel, File, Dir)
- [ ] **TDD GREEN**: Calculate unsupported methods (CRuby - PicoRuby)
- [ ] **TDD GREEN**: Generate `picoruby_supported_methods.json` and `picoruby_unsupported_methods.json`
- [ ] **TDD GREEN**: Copy custom Cop files to `.ptrk_env/{env}/rubocop/lib/`
- [ ] **TDD GREEN**: Generate env-specific `.rubocop-picoruby.yml` in `.ptrk_env/{env}/rubocop/`
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: generate env-specific RuboCop configuration in ptrk env set"

### Phase 3c: Implement current environment tracking
- [ ] **TDD RED**: Write test for `ptrk env current ENV_NAME` command
- [ ] **TDD GREEN**: Implement `ptrk env current` to set/get current environment
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: add ptrk env current command for environment selection"

#### Phase 3c-rubocop: Sync .rubocop.yml with current env

**Design**: Merge env-specific RuboCop config with existing project config
- Use `inherit_from` to reference `.ptrk_env/{env}/rubocop/.rubocop-picoruby.yml`
- Preserves user's existing `.rubocop.yml` settings
- Auto-generates if doesn't exist

- [ ] **TDD RED**: Write test for `.rubocop.yml` placement when `ptrk env current` is set
- [ ] **TDD GREEN**: Create `.rubocop.yml` in project root if not exists
- [ ] **TDD GREEN**: Add `inherit_from: .ptrk_env/{env}/rubocop/.rubocop-picoruby.yml` to `.rubocop.yml`
- [ ] **TDD GREEN**: Preserve user's existing `.rubocop.yml` settings (merge not overwrite)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: generate project .rubocop.yml linked to current env"

### Phase 3d: Support ENV_NAME omission with current fallback
- [ ] **TDD RED**: Write tests for optional ENV_NAME on patch_diff, patch_export, reset, show
- [ ] **TDD GREEN**: Make ENV_NAME optional, default to current environment
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **TDD REFACTOR**: Clean up argument handling
- [ ] **COMMIT**: "feat: make ENV_NAME optional for env commands (default to current)"

### Phase 3e: Remove ptrk env patch_apply
- [ ] **TDD RED**: Write test verifying patch_apply is no longer available
- [ ] **TDD GREEN**: Remove patch_apply command (patches applied during device build)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "refactor: remove patch_apply command (patches applied during build)"

### Phase 3f: Remove ptrk rubocop command
- [ ] **TDD RED**: Write test verifying `ptrk rubocop` is no longer available
- [ ] **TDD GREEN**: Remove RuboCop command class (`lib/picotorokko/commands/rubocop.rb`)
- [ ] **TDD GREEN**: Remove CLI registration from `lib/picotorokko/cli.rb`
- [ ] **TDD GREEN**: Keep RuboCop templates (used in env setup and `ptrk env current`)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "refactor: remove ptrk rubocop command (integrated into ptrk env)"

### Phase 4: Implement .ptrk_build Setup in ptrk device build

**Design**: Separate readonly env cache from build working directory
- `.ptrk_env/{env_name}/` - readonly env (git working copies from env definition)
- `.ptrk_build/{env_name}/` - build working directory (patches, storage/home applied)

#### Phase 4a: Setup .ptrk_build directory structure
- [ ] **TDD RED**: Write test for `.ptrk_build/{env_name}/` directory creation with complete submodule structure
- [ ] **TDD GREEN**: If `.ptrk_build/{env_name}/` doesn't exist, copy entire tree from `.ptrk_env/{env_name}/` (submodules already present)
- [ ] **TDD GREEN**: Skip copy if `.ptrk_build/{env_name}/` already exists (cache optimization)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: setup .ptrk_build directory from env cache with complete submodule structure"

#### Phase 4b: Apply patches to .ptrk_build directory
- [ ] **TDD RED**: Write test for patch application to `.ptrk_build/{env_name}/`
- [ ] **TDD GREEN**: Implement patch application (always run, even if `.ptrk_build/{env_name}/` existed)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: apply patches to .ptrk_build directory"

#### Phase 4c: Reflect storage/home contents
- [ ] **TDD RED**: Write test for storage/home reflection
- [ ] **TDD GREEN**: Copy from `storage/home/` to `.ptrk_build/{env_name}/R2P2-ESP32/storage/home/`
- [ ] **TDD GREEN**: Ensure this runs always (even if `.ptrk_build/{env_name}/` existed)
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "feat: reflect storage/home contents in .ptrk_build directory"

#### Phase 4d: Update ptrk device default env
- [ ] **TDD RED**: Write test for `--env` default as `current` (not `latest`)
- [ ] **TDD GREEN**: Change `ptrk device build` default from `latest` to `current`
- [ ] **TDD RUBOCOP**: Auto-fix style
- [ ] **COMMIT**: "refactor: use current as default env for all device commands"

### Phase 5: End-to-end Verification
- [ ] Verify workflow: `ptrk env set --latest` → `ptrk env current 20251121_060114` → `ptrk device build`
- [ ] Test in playground environment
- [ ] Confirm `.ptrk_env/20251121_060114/R2P2-ESP32/` has complete submodule structure (git submodule update executed)
- [ ] Confirm `.ptrk_build/20251121_060114/R2P2-ESP32/` is copy of .ptrk_env with patches and storage/home applied
- [ ] Verify push is disabled on all repos: `git remote -v` shows no push URL
- [ ] Verify `.ptrk_env/` repos cannot be accidentally modified

---

## Test Execution

**Quick Reference**:
```bash
bundle exec rake test         # Run all tests (unit → integration → scenario → others)
bundle exec rake test:unit    # Unit tests only (fast feedback, ~1.3s)
bundle exec rake test:scenario # Scenario tests (~0.8s)
bundle exec rake ci           # CI checks: all tests + RuboCop + coverage validation
bundle exec rake dev          # Development: RuboCop auto-fix + unit tests
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
- Comprehensive error handling with validation

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
- ✅ Tests: 100% success rate
- ✅ RuboCop: 0 violations
- ✅ Coverage: Targets met (≥85% line, ≥60% branch)
- ✅ Type checking: Steep validation passing
- ✅ Documentation: Updated with code changes

---

## Recent Changes

### Session 2025-11-18: Code Quality Verification
- Verified all identified code quality issues
- All issues confirmed as fixed with proper error handling and test coverage
- Updated documentation to reflect completion status
- Test suite: All tests passing, coverage targets met

### Session 2025-11-17: PicoRuby Development Templates
- Added `.rubocop.yml` template with PicoRuby-specific configuration
- Enhanced `CLAUDE.md` template with:
  - mrbgems dependency management
  - Peripheral APIs (I2C, GPIO, RMT) with examples
  - Memory optimization techniques
  - RuboCop configuration guide
  - Picotest testing framework
- Updated ProjectInitializer to copy template files
- Fixed UTF-8 encoding in tests for international characters

### Previous Sessions: Environment & Build Features
- Session 6: Fixed `ptrk env latest` infrastructure issues
- Session 5: Implemented build environment setup and Gemfile detection

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

## Performance Notes

### Test Execution Performance
- **Parallel execution**: Enabled with multiple workers
- **SimpleCov**: HTMLFormatter in dev, CoberturaFormatter in CI
- **Branch coverage**: CI-only (disabled in dev for speed)

**Monitor with**:
```bash
time bundle exec rake test
```
