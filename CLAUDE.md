# picotorokko Development Guide

Development guidelines for the picotorokko gem — a multi-version build system CLI for PicoRuby application development on ESP32.

## AI Agent Instructions

For comprehensive instructions on development practices, output style, role clarity, playground access control, TODO management, testing patterns, and documentation standards, see:

@import AGENTS.md

## Development Setup

After checking out the repo, install dependencies and run tests:

```bash
bundle install
bundle exec rake test
```

For development workflow, see `.claude/docs/testing-guidelines.md` and `.claude/docs/tdd-rubocop-cycle.md`.

Quality gates (before commit):
- ✅ Tests pass: `bundle exec rake test`
- ✅ RuboCop: 0 violations: `bundle exec rubocop`
- ✅ Coverage ≥ 85% line, ≥ 60% branch: `bundle exec rake ci`
