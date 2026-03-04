# Claude CLI wrapper: project shortcuts and default directory fallback
# Usage: claude                      -> starts claude in the directory set as default in projects
#        claude <project>            -> starts claude in that project's dir
#        claude list                 -> lists available project shortcuts
#        claude <project> [args...]  -> passes extra args to claude
#
# Projects are loaded from projects (same directory as this script).
# If projects does not exist, it is created with default pointing to the current directory.
claude() {
  # Locate projects file alongside this script
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local props_file="$script_dir/projects"

  # Create projects if it doesn't exist
  if [[ ! -f "$props_file" ]]; then
    cat > "$props_file" <<EOF
# Claude project shortcuts
# Format: project-name=/path/to/project
# Add or remove entries here — the claude wrapper script reads this file.
# Lines starting with # are comments and are ignored.
#
# Special entry: default=/path — used when claude is run with no arguments.

default=$PWD
EOF
    echo "Created $props_file with default pointing to: $PWD"
  fi

  # Load projects from file into associative array
  local -A projects=()
  while IFS='=' read -r key value; do
    # Skip blank lines and comments
    [[ -z "$key" || "$key" == \#* ]] && continue
    projects["$key"]="$value"
  done < "$props_file"

  # List available project shortcuts
  if [[ "$1" == "list" ]]; then
    echo "Available project shortcuts (from $props_file):"
    for name in "${!projects[@]}"; do
      echo "  $name -> ${projects[$name]}"
    done
    echo ""
    echo "Usage: claude [project] [args...]"
    return
  fi

  # If a known project name is given, cd into it and run claude
  if [[ -n "$1" && -n "${projects[$1]}" ]]; then
    local dir="${projects[$1]}"
    echo "Project shortcut from claude_wrapper.sh: starting claude in $dir"
    shift
    (cd "$dir" && command claude "$@")
    return
  fi

  # No project name given: run claude in the default directory
  local default_dir="${projects[default]}"
  if [[ -z "$default_dir" ]]; then
    echo "No default directory set. Add 'default=/your/path' to $props_file"
    return 1
  fi
  echo "Default from claude_wrapper.sh: starting claude in $default_dir"
  (cd "$default_dir" && command claude "$@")
}
