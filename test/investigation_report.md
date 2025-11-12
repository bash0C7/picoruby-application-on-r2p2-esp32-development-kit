# Test-Unit Registration Failure Investigation Report

## Problem Statement

When `test/commands/device_test.rb` is run alone via Rake::TestTask:
- **Expected**: 19 tests (all test methods defined in the file)
- **Actual**: 14 tests (5 tests missing from "rake task proxy" sub_test_case)

When `test/device_full_copy.rb` (identical copy, verified by MD5) is run:
- **Result**: 19 tests (all tests register correctly)

## Key Findings

### 1. All Test Methods Are Defined

**TracePoint Investigation** (`test/debug_test_registration.rb`):
- Captured 19 test method definitions during file load
- All `test "..."` blocks were executed
- No errors during class definition phase

### 2. Sub_test_case Instance Methods Are Empty

**ObjectSpace Investigation** (`test/debug_subtestcase.rb`):
- After device_test.rb loads: 8 Test::Unit::TestCase subclasses created
- All sub_test_case classes show: `public_instance_methods(false): []`
- This is normal Test::Unit behavior (tests stored elsewhere internally)

### 3. Missing Tests Identified

**Verbose Output Analysis**:

Tests that register and run (14 total):
- device build command: 2 tests
- device flash command: 4 tests
- device monitor command: 3 tests
- device setup_esp32 command: 2 tests
- device tasks command: 2 tests (+ 1 omitted)
- rake task proxy: **1 test only** (Line 355)

Tests that do NOT register (4 total):
- Line 380: `test "raises error when rake task does not exist"`
- Line 403: `test "delegates rake task with explicit env"`
- Line 429: `test "does not delegate Thor internal methods"`
- Line 437: `test "help command displays available tasks"` (has omit statement)

### 4. Critical Difference: File Path

**Identical Content, Different Results**:
- `test/commands/device_test.rb`: MD5 `f5eaa103f5fb3875ae9549a9544d061d` → 14 tests
- `test/device_full_copy.rb`: MD5 `f5eaa103f5fb3875ae9549a9544d061d` → 19 tests

**Both files have**:
- Same `require "test_helper"` at Line 1
- Same test method definitions
- Same sub_test_case structure

### 5. SystemExit in Missing Tests

**Line 380 uses `assert_raise(SystemExit)`**:
- This is the first test in "rake task proxy" that fails to register
- `test_helper.rb` Line 20-22 mentions: "SystemExit cleanup code removed - device_test.rb is excluded from test suite"
- However, SystemExit happens during test *execution*, not during test *definition*
- Test definition completes (TracePoint confirms all 19 methods defined)

### 6. Test Execution Order Anomaly

**Verbose output shows non-sequential sub_test_case execution**:
1. device build command (defined 3rd, runs 1st)
2. device flash command (defined 1st)
3. device monitor command (defined 2nd)
4. device setup_esp32 command (defined 4th)
5. device tasks command (defined 5th)
6. rake task proxy (defined 6th, only 1/5 tests run)

## Hypotheses

### ❌ Ruled Out

1. **`extractor.tasks` method call**: Proven harmless in isolation
2. **File content differences**: MD5 hashes identical
3. **$LOAD_PATH issues**: Both files use same `require "test_helper"`
4. **Test definition errors**: All 19 test methods successfully defined

### 🤔 Under Investigation

1. **File path-based filtering in Test::Unit**:
   - Only `test/commands/device_test.rb` exhibits the problem
   - `test/device_full_copy.rb` (same content) works fine
   - Possible interaction with Test::Unit's internal file tracking?

2. **Test::Unit::AutoRunner registration process**:
   - Tests defined → 19 methods
   - Tests recognized → 0 methods (before AutoRunner.run)
   - Tests executed → 14 methods (after AutoRunner.run starts)
   - Something stops registration mid-process at Line 380

3. **at_exit hook interference**:
   - Test::Unit uses at_exit hooks for test discovery
   - device_test.rb excluded from main suite (Rakefile Line 17)
   - Possible timing issue with hook execution?

## Next Steps

1. **Deep-dive into Test::Unit source code**:
   - How does `sub_test_case` register tests internally?
   - What triggers the transition from "0 recognized" to "14 executed"?
   - Does AutoRunner have file path filters?

2. **Isolate the exact trigger**:
   - What happens between Line 355 (runs) and Line 380 (doesn't run)?
   - Why does file path matter when content is identical?

3. **Check Test::Unit version-specific behavior**:
   - Current version: test-unit-3.7.1
   - Any known issues with file paths or sub_test_case registration?

## Files Created for Investigation

- `test/debug_test_order.rb` - Track test execution order
- `test/debug_registration_state.rb` - Check Test::Unit registration state
- `test/debug_test_registration.rb` - TracePoint for test method definitions
- `test/debug_subtestcase.rb` - Inspect sub_test_case internal structure
- `test/debug_loadpath.rb` - Verify $LOAD_PATH configuration
- `test/device_full_copy.rb` - Identical copy for comparison
- `/tmp/missing_tests_analysis.md` - Detailed test comparison
