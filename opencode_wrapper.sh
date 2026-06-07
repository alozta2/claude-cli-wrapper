# opencode CLI wrapper: project shortcuts and default directory fallback
# Usage: opencode                      -> starts opencode in the directory set as default in projects
#        opencode <project>            -> starts opencode in that project's dir
#        opencode list                 -> lists available project shortcuts
#        opencode <project> [args...]  -> passes extra args to opencode
#
# Projects are loaded from projects (same directory as this script).
# If projects does not exist, it is created with default pointing to "$HOME".
opencode() {
  # Locate projects file alongside this script
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local props_file="$script_dir/projects"

  # Create projects if it doesn't exist
  if [[ ! -f "$props_file" ]]; then
    cat > "$props_file" <<EOF
# opencode project shortcuts
# Format: project-name=/path/to/project
# Add or remove entries here — the opencode wrapper script reads this file.
# Lines starting with # are comments and are ignored.
#
# Special entry: default=/path — used when opencode is run with no arguments.

default=$HOME
EOF
    echo "Created $props_file with default pointing to: $HOME"
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
    echo "Usage: opencode [project] [args...]"
    return
  fi

  # If a known project name is given, cd into it and run opencode
  if [[ -n "$1" && -n "${projects[$1]}" ]]; then
    local dir="${projects[$1]}"
    echo "Project shortcut from opencode_wrapper.sh: starting opencode in $dir"
    shift
    (cd "$dir" && command opencode "$@")
    return
  fi

  # No project name given: run opencode in the default directory
  local default_dir="${projects[default]}"
  if [[ -z "$default_dir" ]]; then
    echo "No default directory set. Add 'default=/your/path' to $props_file"
    return 1
  fi
  echo "Default from opencode_wrapper.sh: starting opencode in $default_dir"
  (cd "$default_dir" && command opencode "$@")
}
