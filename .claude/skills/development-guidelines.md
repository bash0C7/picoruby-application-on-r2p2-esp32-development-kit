# Development Guidelines

This skill covers coding standards, output style, and documentation rules.

## Output Style & Language

### Response Format

- **Language**: Always Japanese (日本語)
- **Tone**:
  - Default: End with `ピョン。` (cute, casual)
  - Excited: Use `チェケラッチョ！！` when celebrating breakthroughs
- **Code blocks**: Include language tags for syntax highlighting

### Examples

✅ Good response:
```
このファイルを修正しました。LED の制御ロジックが改善されましたピョン。
- 変更点: 色の計算最適化
- テスト: rake monitor で確認済み
```

❌ Avoid:
```
I have fixed this file. The LED control is now optimized.
```

## Code Comments

**Ruby files (.rb)**:
- Language: Japanese
- Style: Noun-ending (体言止め) — no period needed
- Purpose: Explain the *why*, not the *what*

```ruby
# ピクセルの色計算
def calc_color(intensity)
  # 0-255 スケールで正規化
  # グリーンチャネル優先
  [0, intensity, intensity / 2]
end
```

## Documentation Files

**Markdown (.md)**:
- Language: English
- Purpose: Reference material, API docs, architecture
- No Japanese in `.md` files (except code comments within blocks)

## Git Commits

**Format**: English, imperative mood

```
Add LED animation feature
Implement blinking pattern with configurable frequency.

Change-Id: uuid
Co-Authored-By: Claude <noreply@anthropic.com>
```

**Guidelines**:
- Title: 50 chars max, imperative ("Add", "Fix", "Refactor")
- Body: Explain *why* the change matters (if needed)
- Always use `commit` subagent (never raw git commands)

**Examples**:
- ✅ "Add MP3 playback support"
- ✅ "Fix memory leak in LED buffer"
- ✅ "Refactor IMU data reading for clarity"
- ❌ "Added new feature"
- ❌ "Fixed stuff"

## Code Style (Ruby)

### Naming

```ruby
# Constants: UPPER_SNAKE_CASE
LED_COUNT = 25
MAX_BRIGHTNESS = 255

# Methods: snake_case
def set_led_color(index, color)
  # ...
end

# Variables: snake_case
current_intensity = 100
sensor_readings = []
```

### Structure

- Keep methods short (<20 lines when possible)
- Avoid deep nesting (max 2-3 levels for embedded)
- Pre-allocate arrays and buffers
- Use early returns for error conditions

```ruby
def process_sensor_data(raw_data)
  return nil if raw_data.empty?

  # Process...
  normalized = normalize(raw_data)

  return nil if normalized.sum == 0

  apply_filter(normalized)
end
```

## Comments Placement

✅ Explain complex logic:
```ruby
# I2C スレーブアドレス。MPU6886 デフォルト
I2C_ADDR = 0x68
```

✅ Explain *why* a workaround exists:
```ruby
# メモリ制限のため、ローカル配列で予約
colors = Array.new(25, [0, 0, 0])
```

❌ State the obvious:
```ruby
# インクリメント
i += 1

# レッドチャネル設定
color[0] = 255
```

## Error Handling

Prefer defensive patterns:

```ruby
def safe_led_write(index, color)
  # ガード節で早期終了
  return false if index < 0 || index >= 25
  return false if color.nil? || color.size != 3

  # 本処理
  set_pixel(index, color)
  true
end
```

## Documentation Standards

- Add comments for non-obvious logic
- Document public methods with expected inputs/outputs
- Use structured comments for sections:

```ruby
# ============================================
# LED 制御モジュール
# ============================================

# パターン定義
PATTERNS = {
  pulse: [10, 20, 30, 20, 10],
  rainbow: [255, 0, 0, 255, 255, 0, 0, 255]
}
```

## File Headers

Not required for `.rb` files (embedded context is minimal). If needed:

```ruby
# R2P2-ESP32 LED animation engine
# Implements: WS2812B addressable RGB control

require 'atom'
```

## Performance Considerations

- Minimize allocations in loops
- Cache computed values when used multiple times
- Use integer math when possible (avoid Float)
- Profile with `rake monitor` output

## Testing & Verification

- Always test with `rake monitor` before commit
- Check memory usage: `rake check_env`
- Manual verification on hardware when possible
- Include expected behavior in commit messages

## References

- PicoRuby stdlib: Check `.claude/skills/picoruby-constraints.md`
- Hardware pins: Check `.claude/skills/atom-matrix-hardware.md`
- Build system: Check `.claude/skills/project-workflow.md`
