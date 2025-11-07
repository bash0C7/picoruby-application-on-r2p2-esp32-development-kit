# TODO: Project Maintenance Tasks

> **TODO Management Methodology**: See `.claude/skills/project-workflow/SKILL.md` and `CLAUDE.md` ## TODO Management section for task management rules and workflow.

## Future Enhancements (Optional)

### CLI Command Structure Refactoring

- [ ] Consider renaming commands in future if needed (e.g., `pra build-env` or `pra workspace`)

- [ ] Enhance `pra build setup` for complete build preparation
  - [ ] Add PicoRuby build step (call `rake setup_esp32` via ESP-IDF env)
  - [ ] Ensure `pra build setup` handles all pre-build requirements
  - [ ] Update documentation to reflect `pra build setup` capabilities
  - **Status**: `pra build setup` already implemented in `lib/pra/commands/build.rb`, but may need PicoRuby build step integration

- [ ] Update esp32-build.yml template for correct pra command flow
  - [ ] Ensure workflow uses: `pra cache fetch` → `pra build setup` → `pra device build`
  - [ ] Remove internal path exposure (`.cache/*/R2P2-ESP32`)
  - [ ] Remove redundant `pra patch apply` (already done in `pra build setup`)
  - [ ] Validate workflow aligns with local development workflow
  - **Status**: Template exists at `docs/github-actions/esp32-build.yml` (135 lines)
  - **Current Issues**:
    - Uses `idf.py build` directly (line 74-76) instead of `pra device build`
    - Redundant `pra patch apply` call (line 67-71)
    - Internal cache path exposed (`.cache/*/r2p2-esp32`)
  - **Solution**: Update template to use `pra device build` and remove redundant steps

- [ ] Add `--force` option to `pra ci setup` command
  - **Rationale**: CI workflow templates should be "fork and customize" model. Users edit workflows directly (ESP-IDF version, target chip, branches, custom steps). `pra ci setup --force` allows refreshing template while letting users salvage changes via `git diff`.
  - **Location**: `lib/pra/commands/ci.rb` (currently has `setup` subcommand with interactive prompt)
  - **Current Behavior**:
    - Existing file → Shows prompt "Overwrite? (y/N)" → User confirms
  - **New Behavior**:
    - No `--force` + existing file → Error message + exit (fail-fast)
    - `--force` + existing file → Overwrite without confirmation
    - No existing file → Copy template (same as current)
  - **Implementation Details**:
    1. Add `method_option :force, type: :boolean, desc: 'Overwrite existing workflow file'` to `setup` method
    2. Remove interactive prompt logic (lines 34-43 in `lib/pra/commands/ci.rb`)
    3. Replace with:
       ```ruby
       if File.exist?(target_file)
         if options[:force]
           # Proceed with copy
         else
           puts "✗ Error: File already exists: .github/workflows/esp32-build.yml"
           puts "  Use --force to overwrite: pra ci setup --force"
           exit 1
         end
       end
       ```
    4. Update success message to mention `--force` for future updates
  - **Testing Changes** (`test/commands/ci_test.rb`):
    - ❌ Remove: `test "prompts for overwrite when file already exists and user declines"` (lines 66-85)
    - ❌ Remove: `test "overwrites file when user confirms"` (lines 87-108)
    - ❌ Remove: `test "accepts 'yes' as full word for confirmation"` (lines 110-128)
    - ✅ Add: `test "fails when file exists without --force option"` - Verify error message and exit
    - ✅ Add: `test "overwrites file with --force option"` - Verify `Pra::Commands::Ci.start(['setup', '--force'])`
    - Keep: `with_stdin` helper (may be used elsewhere, no harm keeping)
  - **Documentation Updates**:
    1. `docs/CI_CD_GUIDE.md`:
       - Before "Step 1: Copy the Example Workflow" → Add recommendation to use `pra ci setup`
       - Add new section "Updating Workflow Template":
         ```markdown
         #### Updating Workflow Template

         When `pra` gem is updated with workflow improvements:

         ```bash
         gem update pra
         pra ci setup --force  # Overwrite with latest template
         git diff .github/workflows/esp32-build.yml  # Review changes
         # Salvage any custom changes you need
         ```
         ```
    2. Consider adding `pra ci setup` mention in main README.md if relevant
  - **Related Context**: Original TODO planned "Add CI/CD update command" with `pra ci update` subcommand. Analysis showed workflow templates are meant to be "fork and customize" by users (documented in CI_CD_GUIDE.md). Rather than Bmodel (config-based), Amodel (user ownership) is more appropriate, so `pra ci setup --force` is the right pattern.
