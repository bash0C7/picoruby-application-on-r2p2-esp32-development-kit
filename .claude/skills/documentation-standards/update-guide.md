# Documentation Update Implementation Guide

This guide provides step-by-step instructions for updating documentation when code changes.

## Documentation Change Matrix

### 1. Command Implementation Changed

**Files to update**:
- [ ] `docs/SPECIFICATION.md` — Update command signature and behavior description
- [ ] `README.md` — Update Quick Start section if user-facing command
- [ ] Relevant guide in `docs/` — If affects CI/CD, mrbgems, testing, or setup

**Example**:
```markdown
# In docs/SPECIFICATION.md under "Environment Management":
### ptrk env set

Updates or creates an environment...
```

**Commit message**:
```
feat: implement ptrk device build command

Update docs/SPECIFICATION.md Device Operations section.
Update README.md Quick Start section.
```

### 2. API or Public Method Changed

**Files to update**:
- [ ] Source code — Update/add rbs-inline annotations
- [ ] `.rbs` files — Run `rake rbs:generate` after annotation changes
- [ ] `docs/` — Reference architecture documents if needed

**Example**:
```ruby
# In lib/picotorokko/commands/device.rb
# sig { (String) -> void }
def build(env_name)
  # Implementation
end
```

**Verify**:
```bash
bundle exec rake rbs:generate
```

**Commit message**:
```
refactor: update Device#build signature

Add rbs-inline annotations reflecting new parameter handling.
Regenerate sig/generated/*.rbs files.
```

### 3. Template or Workflow Changed

**Files to update**:
- [ ] `docs/CI_CD_GUIDE.md` — GitHub Actions workflow changes
- [ ] `docs/PROJECT_INITIALIZATION_GUIDE.md` — Project template changes
- [ ] `docs/MRBGEMS_GUIDE.md` — mrbgem creation or configuration changes
- [ ] `README.md` — If affects user quickstart

**Example**:
```markdown
# In docs/CI_CD_GUIDE.md under "GitHub Actions Setup":

To set up automated builds, use the `--with-ci` flag...
```

**Commit message**:
```
feat: add GitHub Actions workflow for CI/CD

Update docs/CI_CD_GUIDE.md with setup instructions.
Update docs/PROJECT_INITIALIZATION_GUIDE.md for template changes.
```

### 4. Architecture or Design Changed

**Files to update**:
- [ ] `.claude/docs/` design documents — Architecture, patterns, rationale
- [ ] Related architecture docs in `docs/architecture/` if user-relevant
- [ ] `AGENTS.md` — If affects AI instructions or development patterns

**Example**:
```markdown
# In .claude/docs/executor-abstraction-design.md

## Pattern: Executor Abstraction

The Executor pattern provides...
```

**Commit message**:
```
refactor: update executor abstraction for new use case

Update .claude/docs/executor-abstraction-design.md with new pattern.
Includes examples and test strategy.
```

### 5. Multiple Files Changed (Full Feature)

**Workflow**:
1. Identify all affected areas (command, API, templates, architecture)
2. Create list of files to update from matrices above
3. Update in logical order: specification → API docs → guides
4. Verify all links and cross-references
5. Commit with comprehensive message

**Commit message**:
```
feat: implement mrbgem dependency resolution

Updates:
- docs/SPECIFICATION.md: New mrbgems commands
- docs/MRBGEMS_GUIDE.md: Dependency syntax and examples
- README.md: Quick Start section with new features
- .claude/docs/mrbgem-system-design.md: Architecture

Add rbs-inline annotations for new public APIs.
Regenerate sig/generated/*.rbs files.
```

## Quality Checklist

Before committing documentation changes:

- [ ] **No historical context** — Removed all "was", "previously", "legacy", etc.
- [ ] **All examples work** — Code examples match current implementation
- [ ] **Links correct** — All cross-references point to actual files
- [ ] **Audience clear** — User-facing vs. developer-facing sections are distinct
- [ ] **Specification first** — Behavior described in `docs/SPECIFICATION.md` is source of truth
- [ ] **Consistency** — Terminology, formatting, structure match existing docs
- [ ] **Section headers** — Match documentation structure conventions
- [ ] **No redundancy** — Information not duplicated across files unnecessarily

## Common Patterns

### Updating Command Specification

```markdown
### ptrk [command] [subcommand]

**Usage**:
```bash
ptrk command subcommand [OPTIONS]
```

**Options**:
- `--option` — Description

**Behavior**:
- Detailed explanation of what command does
- Important edge cases
- Related commands

**Example**:
```bash
$ ptrk command subcommand
Output description
```
```

### Updating Guides

```markdown
## Topic Name

Brief intro paragraph.

### Subsection

Step-by-step or detailed explanation.

#### Example

```bash
Code example or setup
```

### Troubleshooting

Common issues and solutions.
```

### Updating README Sections

```markdown
#### Feature Name

Brief description.

```bash
# Usage example
```

See [docs/GUIDE_NAME.md](docs/GUIDE_NAME.md) for detailed documentation.
```

## Reference Links

- **Specification**: See `AGENTS.md` — When to Update Documentation section
- **File Structure**: See `AGENTS.md` — Key Development Files section
- **Quality Rules**: See `AGENTS.md` — Documentation Quality Rules section
- **Design Documents**: See `.claude/docs/documentation-automation-design.md` for mapping

## When In Doubt

1. Check `docs/SPECIFICATION.md` to see how similar features are documented
2. Look at README.md for user-facing feature patterns
3. Review related docs for tone and structure
4. Ask: "Would a new user understand this?"
5. Ask: "Would another developer know exactly what this does?"
