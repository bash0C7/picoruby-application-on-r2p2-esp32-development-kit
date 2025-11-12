# TODO: Project Maintenance Tasks

## Current Status

- ✅ **All Tests**: 197 tests passing (183 main + 14 device)
- ✅ **Quality**: RuboCop clean, coverage 87.14% line / 65.37% branch
- ✅ **Infrastructure**: Executor abstraction, Template engines, Device test framework complete

---

## Test Execution

**Quick Reference**:
```bash
rake              # Default: Run all tests (183 main + 14 device)
rake test         # Run main test suite (183 tests)
rake ci           # CI checks: tests + RuboCop + coverage validation
rake dev          # Development: RuboCop auto-fix + tests + coverage
```

**Quality Metrics**:
- Tests: 197 total, all passing ✓
- Coverage: 87.14% line, 65.37% branch (minimum: 85%/60%)
- RuboCop: 0 violations

---

## Completed Infrastructure

- ✅ Executor abstraction (ProductionExecutor, MockExecutor)
- ✅ AST-based template engines (Ruby, YAML, C)
- ✅ Device test framework integration
- ✅ Command name refactoring (pra → picotorokko)
- ✅ Rake task simplification (CI vs development)
