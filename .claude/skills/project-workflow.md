# Project Workflow & Build System

This skill covers development process, project structure, and build permissions.

## Project Structure

```
.
├── src_components/R2P2-ESP32/storage/home/
│   └── app.rb                 # Main app (auto-runs on boot)
├── build_config/
│   └── xtensa-esp.rb          # Build configuration
├── Rakefile                   # Build system
├── CHANGELOG.md               # Version history
└── CLAUDE.md                  # This guide (compact)
```

## Development Workflow

### 1. Investigate
Use `explore` subagent to understand code structure before making changes.

```bash
# Example: understand mrbgem structure
# → Use Explore agent with keyword "mrbgems" or "build_config"
```

### 2. Plan
When complex features needed, use `ExitPlanMode` to present implementation plan.

### 3. Implement
Make small, incremental changes. Test locally with `rake monitor` first.

### 4. Commit
**MUST use `commit` subagent** (never raw git commands):
- English, imperative mood
- Example: "Add LED animation feature"

### 5. User Verifies
User runs `rake build` / `rake flash` after commit approval.

## Rake Commands Permissions

### ✅ Always Allowed (Safe, Read-Only)

```bash
rake monitor      # Watch UART output in real-time
rake check_env    # Verify ESP32 and build environment
```

### ❓ Ask First (Time-Consuming)

```bash
rake build        # Compile firmware (2-5 min)
rake cleanbuild   # Clean + rebuild
rake flash        # Upload to hardware (requires device)
```

### 🚫 Never Execute (Destructive)

```bash
rake init         # Contains git reset --hard
rake update       # Destructive git operations
rake buildall     # Combines destructive ops
```

**Rationale**: Protect work-in-progress from accidental `git reset --hard`.

## Git Safety Protocol

- ✅ Use `commit` subagent for all commits
- ❌ Never: `git push`, `git push --force`, raw `git commit`
- ❌ Never: `git reset --hard`, `git rebase -i`
- ✅ Safe: `git status`, `git log`, `git diff`

## Build Optimization Tips

1. **Memory checks**: Run `rake check_env` before large changes
2. **Incremental builds**: Use `rake build` only after meaningful changes
3. **Monitor output**: Use `rake monitor` to catch runtime errors early
4. **Commit small**: Frequent small commits are safer than large batches

## Typical Session Flow

```
1. Read CHANGELOG.md to understand current state
2. Use explore agent to review relevant code/mrbgems structure
3. Make targeted edits (small, focused)
4. Commit with clear message via `commit` subagent
5. User verifies with `rake build` / `rake check_env`
6. User tests on hardware with `rake flash` (if applicable)
```

## References

- ESP-IDF build: [Espressif Tools](https://docs.espressif.com/projects/esp-idf)
- R2P2-ESP32: [GitHub repo](https://github.com/picoruby)
- Rake task reference: `rake -T` (list all available tasks)
