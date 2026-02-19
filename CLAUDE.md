# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ansible role that installs [Prezto](https://github.com/sorin-ionescu/prezto) (a Zsh configuration framework) for users on Linux or macOS. Published to Ansible Galaxy as `brianhartsock.prezto`.

## Commands

### Setup
```bash
uv sync
pre-commit install
```

### Linting
```bash
uv run ansible-lint
uv run yamllint .
uv run flake8
# or all at once:
uv run pre-commit run --all-files
```

### Testing (Molecule + Docker + testinfra)
```bash
uv run molecule test                    # default scenario (Ubuntu 22.04 + 24.04)
uv run molecule test -s check_mode      # check mode scenario (Ubuntu 24.04)
```

Step-by-step for debugging:
```bash
uv run molecule create && uv run molecule prepare && uv run molecule converge && uv run molecule verify
```

### Dependency Management
```bash
uv lock    # regenerate uv.lock from pyproject.toml
```

## Architecture

The role has two tasks in `tasks/main.yml`:
1. Clone the Prezto git repo (recursive submodules) using `ansible.builtin.git`
2. Symlink six Zsh runcom files (`zlogin`, `zlogout`, `zpreztorc`, `zprofile`, `zshenv`, `zshrc`) from `~/.zprezto/runcoms/` into the user's home directory

Role variables are in `defaults/main.yml` (repo URL, destination, host key acceptance, version).

## Key Conventions

- Use fully-qualified collection names for modules (e.g., `ansible.builtin.git`, not `git`)
- The symlink task guards against check mode with `when: 'not ansible_check_mode'`; the `check_mode` molecule scenario validates this
- `.ansible-lint` skips the `yaml` rule since yamllint handles YAML linting separately
- `.yamllint` allows up to 160-character lines
- Pre-commit hooks use `language: system` (tools must be installed in the active virtualenv)

## CI

CI runs on `ubuntu-latest` via GitHub Actions (`.github/workflows/ci.yml`) with two jobs:

1. **Lint** -- runs `ansible-lint`, `yamllint`, and `flake8`
2. **Molecule** (`needs: lint`) -- runs both the default and `check_mode` molecule scenarios

Both jobs check out the repo into a directory named `brianhartsock.zprezto` so molecule can resolve the role name correctly. Locally this is not required.

A separate release workflow (`.github/workflows/release.yml`) publishes the role to Ansible Galaxy on GitHub release events.

## Development Workflow

Follow this workflow for all code changes.

```
Code → Document → Verify → Code Review
  ^                              |
  └──── fix issues ──────────────┘
```

### 1. Code

Make the implementation changes. Use FQCNs, name all tasks, and follow the patterns in existing task files.

### 2. Document

Update README.md and CLAUDE.md to reflect any changes to variables, platforms, commands, or architecture. If the ansible plugin is installed, use the `documentator` agent.

### 3. Verify

Run linters (yamllint, ansible-lint, flake8), pre-commit hooks, and molecule tests. All checks must pass before proceeding. If the ansible plugin is installed, use the `verifier` agent.

### 4. Code Review

Review the changes for Ansible best practices, idempotency, security, cross-platform correctness, and test coverage. If the ansible plugin is installed, use the `code-reviewer` agent.

### 5. Iterate

If verification or code review flags issues, fix them and repeat from step 2. Continue until all checks pass and the review is clean.
