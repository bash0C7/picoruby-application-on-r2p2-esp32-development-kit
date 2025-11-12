# device_test.rb テスト登録失敗の分析結果

## 実行状況

### 実行されたテスト (14 tests + 1 omitted)

**device build command** (2 tests):
- Line 193: raises error when environment not found ✓
- Line 211: shows message when building ✓

**device flash command** (4 tests):
- Line 68: raises error when build environment not found ✓
- Line 32: raises error when environment not found ✓
- Line 50: raises error when no current environment is set ✓
- Line 98: shows message when flashing ✓

**device monitor command** (3 tests):
- Line 129: raises error when environment not found ✓
- Line 147: raises error when no current environment is set ✓
- Line 165: shows message when monitoring ✓

**device setup_esp32 command** (2 tests):
- Line 239: raises error when environment not found ✓
- Line 257: shows message when setting up ESP32 ✓

**device tasks command** (2 tests executed, 1 omitted):
- Line 285: raises error when environment not found ✓
- Line 303: raises error when no current environment is set ✓
- Line 321: shows available tasks for environment ⊘ (OMITTED)

**rake task proxy** (1 test executed):
- Line 355: delegates custom_task to R2P2-ESP32 rake task ✓

### 登録されなかったテスト (4 tests)

**rake task proxy** の残り4つ:
- Line 380: raises error when rake task does not exist ✗
- Line 403: delegates rake task with explicit env ✗
- Line 429: does not delegate Thor internal methods ✗
- Line 437: help command displays available tasks ✗

## 重要な発見

1. **sub_test_case レベルでの途切れ**: rake task proxy sub_test_case の最初の1つだけが実行され、残りの4つが登録されていない

2. **実行順序の異常**: verbose 出力では sub_test_case の順序が混在している（device build が最初に実行されている）

3. **総テスト数**: 19 tests (定義) → 14 tests (実行) + 1 omitted + 4 not registered
