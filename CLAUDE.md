# picotorokko Development Guide

Development guidelines for the picotorokko gem — a multi-version build system CLI for PicoRuby application development on ESP32.

## AI Agent Instructions

For AI-specific instructions (output style, role clarity, playground access control, TODO management, testing patterns, etc.), see:

@import AGENTS.md

## Ruby Version Policy

**Target Ruby: 3.4+** (3.3 fully supported; both versions verified compatible)

- ✅ **Ruby 3.4+ is the primary target** — All string literals default to frozen (no pragma needed)
- ✅ **Ruby 3.3 full compatibility verified**
- 🚫 **NO `# frozen_string_literal: true` pragma** — Not needed in Ruby 3.4+

## Gem Development

**Dependency Management** (gemspec centralization):
- ✅ **All dependencies go in `picotorokko.gemspec`** — Single source of truth
  - Runtime: `spec.add_dependency`
  - Development: `spec.add_development_dependency`
- ✅ **Gemfile must be minimal** — Only `source` + `gemspec` directive
- 🚫 **Never duplicate dependencies in Gemfile**

## R2P2-ESP32 Runtime Integration

**CRITICAL: ptrk gem has ZERO knowledge of ESP-IDF**

The `ptrk` gem is a **build tool only**. It knows:
- ✅ R2P2-ESP32 project directory structure
- ✅ R2P2-ESP32 Rakefile exists and has callable tasks
- ✅ How to invoke Rake in that directory: `bundle exec rake <task>`

The `ptrk` gem does **NOT** know:
- 🚫 Where ESP-IDF is located
- 🚫 How to source `export.sh`
- 🚫 ESP-IDF environment variables or setup
- 🚫 Specific Rake task names (they may change)

**Implementation Rule**:
- When `ptrk` needs to build/flash/monitor, it **delegates to R2P2-ESP32 Rakefile**
- The Rakefile in R2P2-ESP32 handles all ESP-IDF setup internally

## Key Development Files

**For gem developers** (you read/write these):
- `.claude/docs/` — Internal design documents, architecture, implementation guides
- `.claude/skills/` — Agent workflows for your development process
- `AGENTS.md` — AI instructions
- `CLAUDE.md` — Development guidelines (this file)
- `lib/picotorokko/` — Source code
- `test/` — Test suite

**For ptrk users** (they read these):
- `README.md` — Installation and quick start
- `SPEC.md` — Complete specification of ptrk commands and behavior
- `docs/` — User guides (CI/CD, mrbgems, RuboCop, etc.)
- `docs/github-actions/` — Workflow templates for GitHub Actions

## Development Workflow

See `.claude/docs/testing-guidelines.md` and `.claude/docs/tdd-rubocop-cycle.md` for comprehensive testing and refactoring guidance.

### Quality Gates

**ALL must pass before commit**:
- ✅ Tests pass: `bundle exec rake test`
- ✅ RuboCop: 0 violations: `bundle exec rubocop`
- ✅ Coverage ≥ 85% line, ≥ 60% branch: `bundle exec rake ci`

### Documentation Updates

When implementation changes:
- Command behavior? → Update `SPEC.md` + `README.md`
- Template/workflow? → Update `docs/CI_CD_GUIDE.md` + `docs/MRBGEMS_GUIDE.md`
- Public API? → Update rbs-inline annotations
- Reference: `.claude/docs/documentation-automation-design.md` for file mapping

## Output Style

See `AGENTS.md` for AI output style guidelines.
