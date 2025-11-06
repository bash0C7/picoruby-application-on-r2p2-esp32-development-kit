# PicoRuby Development Constraints

This skill is auto-loaded when editing `.rb` files or discussing memory optimization.

## Memory & Runtime Limits

- **Total heap**: 520KB (strict limit)
- **Nesting depth**: Avoid deep recursion; prefer iterative solutions
- **String handling**: Pre-allocate when possible; avoid repeated concatenation
- **Arrays**: Use fixed-size when known; minimize dynamic growth during tight loops

## PicoRuby vs CRuby

| Feature | PicoRuby | CRuby |
|---------|----------|-------|
| Gems | ❌ No bundler/gems | ✅ Full ecosystem |
| stdlib | Minimal (R2P2-ESP32 only) | Complete stdlib |
| Memory | ~520KB heap | GB+ available |
| GC | Simple mark-sweep | Complex generational |
| Float math | ⚠️ Limited precision | Full IEEE 754 |

## PicoRuby-safe stdlib

**Available**:
- `Array#each`, `#map`, `#select` (avoid `#each_with_index` in tight loops)
- `Hash` (simple key-value)
- `String` (basic methods, avoid regex for embedded)
- `Time` (limited; ESP32 time depends on system clock)
- `File` (via R2P2-ESP32 abstraction)

**Unavailable**:
- Regex (use string matching instead)
- Threads (single-threaded runtime)
- Fiber/Enumerator (complex control flow not needed)

## Common Patterns

✅ **Good**:
```ruby
# Pre-allocate arrays
leds = Array.new(25, [0, 0, 0])

# Simple iteration
leds.each { |led| process(led) }

# Tail recursion converted to loop
depth = 0
while depth < max_depth
  process(depth)
  depth += 1
end
```

❌ **Avoid**:
```ruby
# Dynamic growth in loop
buffer = []
1000.times { |i| buffer << i }  # Memory spikes

# Deep nesting
def recursive_calc(n)
  recursive_calc(n - 1)  # Stack overflow risk
end

# Heavy string ops
str = ""
100.times { |i| str += i.to_s }  # Excessive allocation
```

## References

- R2P2-ESP32 GitHub: [picoruby](https://github.com/picoruby)
- ESP-IDF memory: heap fragmentation on embedded systems
