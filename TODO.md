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

## ⚠️ Known Issues (Unresolved)

### [TODO-INFRASTRUCTURE-DEVICE-TEST] Thor help command breaks test-unit registration

**Status**: Omitted (low priority)

**Verification**: Commit 64df24f - Confirmed that Thor help command breaks test-unit registration:
- Mixed device_test with main tests (removed delete_if)
- Enabled help test (removed omit)
- **Result**: Only 65/197 tests registered (132+ tests fail to register)
- **Impact**: Help command cannot be tested alongside main test suite
- **Current solution**: Keep device tests isolated via `test:device_internal` task

**Reason for omit**:
- Display-only feature (non-critical)
- `help` command works manually
- No user-facing impact (CI/CD unaffected)

**Next steps if needed**:
- Investigate test-unit + Thor hook interaction
- Consider alternative testing strategy for device commands
- May require refactoring test infrastructure

---

## Completed Infrastructure

- ✅ Executor abstraction (ProductionExecutor, MockExecutor)
- ✅ AST-based template engines (Ruby, YAML, C)
- ✅ Device test framework integration
- ✅ Command name refactoring (pra → picotorokko)
- ✅ Rake task simplification (CI vs development)
