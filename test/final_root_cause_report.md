# Final Root Cause Report: test/commands/ + Complex Test Content

## Executive Summary

The test registration failure is caused by the **combination** of:
1. Test file placed in `test/commands/` directory
2. Complex test content with resource-intensive operations
3. Test::Unit's internal handling of nested directory structures

## Key Findings

### 1. Directory Location Matters

**Evidence**:
- `test/commands/*.rb` → 14 tests (incomplete)
- `test/*.rb` (root) → 19 tests (complete)

This was consistently reproduced across multiple file variations.

### 2. Test Content Matters MORE Than Structure

**Critical Discovery**:

**Simplified tests (all pass)**:
```ruby
# 6 sub_test_cases with simple assert_true(true) → All tests execute ✓
sub_test_case "rake task proxy" do
  test "test 1" do
    assert_true(true)
  end
  test "test 2" do
    assert_true(true)
  end
  test "test 3" do
    assert_true(true)
  end
end
```

**Real device_test.rb tests (incomplete)**:
```ruby
# Same 6 sub_test_cases with real test content → Only 1 test executes ❌
sub_test_case "rake task proxy" do
  test "delegates custom_task..." do
    with_fresh_project_root do
      Dir.mktmpdir do |tmpdir|
        Dir.chdir(tmpdir)
        setup_test_environment('test-env')
        with_esp_env_mocking do |_mock|
          output = capture_stdout do
            Picotorokko::Commands::Device.start(['custom_task', '--env', 'test-env'])
          end
          assert_match(/Delegating/, output)
        end
      end
    end
  end
  # ... 4 more tests (NOT executed)
end
```

### 3. omit Is NOT The Root Cause

**Tested variations**:
- Empty test: ✓ All rake proxy tests execute
- Test with omit only: ✓ All rake proxy tests execute  
- Test with omit + unreachable code: ✓ All rake proxy tests execute
- **BUT** in actual device_test.rb with real content: ❌ Only 1 test executes

**Conclusion**: Line 321's omit is a red herring. The issue is triggered by cumulative complexity of preceding tests.

### 4. Sub_test_case Count Is NOT The Issue

**Tested**:
- 2 sub_test_cases: ✓ Works
- 6 sub_test_cases (simplified): ✓ Works
- 6 sub_test_cases (real content): ❌ Fails

**Conclusion**: Number of sub_test_cases doesn't matter; content does.

### 5. All Tests ARE Registered

**suite.tests inspection shows**:
```
suite.tests: 5 tests
Test names:
  1. test: delegates custom_task to R2P2-ESP32 rake task
  2. test: delegates rake task with explicit env
  3. test: does not delegate Thor internal methods
  4. test: help command displays available tasks
  5. test: raises error when rake task does not exist
```

**But verbose output shows**:
```
rake task proxy:
  test: delegates custom_task to R2P2-ESP32 rake task:	
Finished in 0.09 seconds.
```

**Conclusion**: Tests are registered but not executed. Problem occurs during test **execution**, not registration.

## Root Cause Hypothesis

Test::Unit's test runner encounters an issue when:

1. **File location**: `test/commands/` subdirectory (not root)
2. **Test complexity**: Multiple preceding sub_test_cases with resource-intensive operations:
   - Temporary directory creation (`Dir.mktmpdir`)
   - Directory changes (`Dir.chdir`)
   - Project root mocking (`with_fresh_project_root`)
   - ESP environment mocking (`with_esp_env_mocking`)
   - Thor command execution (`Picotorokko::Commands::Device.start`)
   - Stdout capture (`capture_stdout`)

3. **Cumulative effect**: After 5 sub_test_cases of complex operations, Test::Unit's runner appears to:
   - Enter an inconsistent state
   - Display the first test name of 6th sub_test_case
   - Fail to execute the test or subsequent tests
   - Proceed directly to "Finished"

## Possible Technical Causes

1. **Resource exhaustion**: Temporary files/directories not fully cleaned up
2. **State contamination**: Global state (Dir.pwd, ENV, $stdout) left in inconsistent state
3. **Test::Unit internal buffer**: Nested directory handling hits internal limits
4. **Hook interference**: at_exit or teardown hooks not executing properly in subdirectories

## Workaround Strategies

### Strategy 1: Move to Root Directory ✅ VERIFIED

```bash
mv test/commands/device_test.rb test/device_commands_test.rb
```

**Result**: All 19 tests execute successfully.

### Strategy 2: Simplify Test Content (NOT RECOMMENDED)

Reducing test complexity would weaken test coverage.

### Strategy 3: Split Into Multiple Files

Split device_test.rb into smaller files:
- `test/device_flash_test.rb`
- `test/device_monitor_test.rb`
- `test/device_tasks_test.rb`
- `test/device_rake_proxy_test.rb`

Each file with 1-2 sub_test_cases only.

### Strategy 4: Investigate Test::Unit Source

Deep-dive into Test::Unit::AutoRunner to understand why nested directories cause execution failure with complex test content.

## Recommended Solution

**Move device_test.rb to test/ root directory**:

```bash
git mv test/commands/device_test.rb test/device_commands_test.rb
# Update any references in Rakefile, documentation
```

**Pros**:
- ✅ Immediate fix (verified to work)
- ✅ No code changes needed
- ✅ All tests execute properly

**Cons**:
- ⚠️ Loses organizational structure (commands subdirectory)
- ⚠️ Doesn't fix underlying Test::Unit issue

## Alternative: Test Directory Restructuring

If maintaining subdirectory structure is important, reorganize as:

```
test/
  unit/
    commands/
      device_test.rb  # Keep here
  integration/        # If needed
```

Then update Rake::TestTask to explicitly load from `test/unit/`.

## Conclusion

The root cause is a complex interaction between:
- Test::Unit's handling of `test/commands/` subdirectory
- Cumulative resource usage from complex test operations
- Execution failure (not registration failure) in 6th sub_test_case

**Immediate fix**: Move file to `test/` root directory.

**Long-term**: Consider filing a bug report to test-unit maintainers with reproduction case.
