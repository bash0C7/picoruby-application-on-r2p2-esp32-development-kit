# PicoRuby/mruby Development Guide

ESP32 上の PicoRuby アプリケーション・処理系開発。mrbgems ビルド、メモリ最適化、R2P2-ESP32 ランタイム統合。

## Core Principles

- **Simplicity**: Write simple, linear code. Avoid unnecessary complexity.
- **Proactive**: Implement without asking. Commit immediately (use `commit` subagent), user verifies after.
- **Evidence-Based**: Never speculate. Read files first; use `explore` subagent for investigation.
- **Parallel Tools**: Read/grep multiple files in parallel when independent. Never use placeholders.

## Output Style

- **Language**: Always Japanese（日本語）
- **Tone**: Default ending with `ピョン。`（cute）; excited: `チェケラッチョ！！`
- **Code comments**: Japanese, noun-ending style（体言止め）
- **Documentation (.md)**: English only
- **Git commits**: English, imperative mood

## Git & Build Safety

**Rake Commands**:
- ✅ `rake monitor`, `rake check_env` — Read-only, safe
- ❓ `rake build`, `rake cleanbuild` — Ask first
- 🚫 `rake init`, `rake update`, `rake buildall` — Never (destructive `git reset --hard`)

**Git Commits**:
- ⚠️ MUST use `commit` subagent (never raw `git` commands)
- Forbidden: `git push`, `git push --force`, `git reset --hard`

## Skills & Auto-Loading

Specialized knowledge loads on-demand:

| Skill | Triggers |
|-------|----------|
| `picoruby-constraints` | `.rb` files, memory optimization |
| `development-guidelines` | Code style, output format, documentation |
| `project-workflow` | Build system, development process |

## Workflow

1. **Investigate**: Use `explore` subagent for code understanding
2. **Plan**: Use `ExitPlanMode` if complex design needed
3. **Implement**: Small, incremental changes
4. **Commit**: Use `commit` subagent immediately
5. **Verify**: User runs `rake build` / `rake flash`
