# Claude CLI Wrapper

Shell wrapper for the `claude` command that adds project shortcuts and a configurable default directory.

## Setup

1. Add to your `~/.bashrc` or `~/.zshrc`:
   ```sh
   source /path/to/claude-cli-wrapper/claude_wrapper.sh
   ```

2. Reload your shell:
   ```sh
   source ~/.bashrc
   ```

3. Edit the `projects` file (created automatically on first run) to add your project shortcuts.

## Projects file

Located alongside `claude_wrapper.sh`. Created automatically on first run with `default` set to the current directory.

```
# Special entry: default=/path — used when claude is run with no arguments.
default=/your/default/path

# Project shortcuts
my-project=/path/to/my-project
```

## Usage

- `claude` — start Claude in the `default` directory
- `claude <project>` — start Claude in the named project's directory
- `claude list` — list all configured project shortcuts
- `claude <project> [args...]` — pass extra args to Claude
