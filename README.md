# opencode CLI Wrapper

Shell wrapper for the `opencode` command that adds project shortcuts and a configurable default directory.

## Setup

1. Add to your `~/.bashrc` or `~/.zshrc`:
   ```sh
   source /path/to/opencode-cli-wrapper/opencode_wrapper.sh
   ```

2. Reload your shell:
   ```sh
   source ~/.bashrc
   ```

3. Edit the `projects` file (created automatically on first run) to add your project shortcuts.

## Projects file

Located alongside `opencode_wrapper.sh`. Created automatically on first run with `default` set to `$HOME`.

```
# Special entry: default=/path — used when opencode is run with no arguments.
default=~

# Project shortcuts
my-project=/path/to/my-project
```

## Usage

- `opencode` — start opencode in the `default` directory
- `opencode <project>` — start opencode in the named project's directory
- `opencode list` — list all configured project shortcuts
- `opencode <project> [args...]` — pass extra args to opencode
