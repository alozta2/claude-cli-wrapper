# AGENTS.md

## What this is
A tiny shell wrapper for the `opencode` command. It defines a bash function
`opencode()` (in `opencode_wrapper.sh`) that adds project shortcuts and a
configurable default working directory. It is meant to be sourced from
`~/.bashrc` / `~/.zshrc`.

## Files
- `opencode_wrapper.sh` — the wrapper logic (single `opencode()` function).
- `projects` — user config, `name=/path` pairs. Git-ignored (see `.gitignore`).
- `projects.example` — template committed to the repo.
- `README.md` — setup/usage docs.

## projects file format
- One entry per line: `project-name=/path/to/project`.
- Lines starting with `#` are comments; blank lines ignored.
- Special entry `default=/path` — used when `opencode` is run with no arguments.
- Auto-created (with `default=$HOME`) on first run if missing.

## Behavior
- `opencode` — run in `default` dir.
- `opencode <project>` — cd into that project's dir and run.
- `opencode <project> [args...]` — extra args passed through to real `opencode`.
- `opencode list` — list configured shortcuts.

## Notes
- Pure bash; no build, test, or lint steps.
- To add/remove shortcuts, edit `projects` (keep `projects.example` in sync when
  the format changes).
