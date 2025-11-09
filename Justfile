set positional-arguments := true

GREEN := '\033[1;32m'
RED := '\033[1;31m'
CLEAR := '\033[0m'
HOSTNAME := `hostname`
FLAKE := trim_end_match(HOSTNAME, ".local")
SYSTEM := "darwinConfigurations." + FLAKE + ".system"
export NIXPKGS_ALLOW_UNFREE := "1"

# Switch to a new generation and clean up
switch: (rebuild-switch) clean

# Build the nix-darwin configuration
build:
    @echo -e "{{ GREEN }}Starting...{{ CLEAR }}"
    darwin-rebuild build --flake .

# Switch to a new generation
rebuild-switch:
    @echo -e "{{ GREEN }}Switching to new generation...{{ CLEAR }}"
    sudo darwin-rebuild switch --flake .

upgrade:
    nix flake update --commit-lock-file

alias optimise-store := optimize-store

# Optimize the nix store
optimize-store:
    nix store optimise

clean:
    @echo -e "{{ GREEN }}Cleaning up...{{ CLEAR }}"
    rm -rf ./result

# Switch to update-YYYYMMDD branch, creating if needed
update-branch:
    #!/usr/bin/env bash
    set -euo pipefail
    BRANCH="update-$(date +%Y%m%d)"
    if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
        echo -e "{{ GREEN }}Switching to existing branch: $BRANCH{{ CLEAR }}"
        git checkout "$BRANCH"
    else
        echo -e "{{ GREEN }}Creating and switching to new branch: $BRANCH{{ CLEAR }}"
        git checkout -b "$BRANCH"
    fi

# Temporarily edit a Nix-managed read-only config file
edit-config FILE:
    @{{ justfile_directory() }}/scripts/config-edit.sh edit "{{ FILE }}"

# Restore a config file from backup
restore-config FILE *ARGS:
    @{{ justfile_directory() }}/scripts/config-edit.sh restore "{{ FILE }}" {{ ARGS }}

# Sync Claude commands from project to ~/.claude/commands/
sync-claude-commands:
    #!/usr/bin/env bash
    set -euo pipefail
    
    SOURCE_DIR="{{ justfile_directory() }}/home/claude-code"
    TARGET_DIR="$HOME/.claude/commands"
    
    # Create target directory
    mkdir -p "$TARGET_DIR"
    
    # Copy files (without --delete flag)
    echo "Syncing Claude commands..."
    rsync -av \
        --include="*.md" \
        --include="*/" \
        --exclude="*" \
        "$SOURCE_DIR/" \
        "$TARGET_DIR/"
    
    # Check for extra files in target that don't exist in source
    echo -e "\nChecking for extra files..."
    EXTRA_FILES=()
    while IFS= read -r -d '' file; do
        REL_PATH="${file#$TARGET_DIR/}"
        if [[ ! -f "$SOURCE_DIR/$REL_PATH" ]]; then
            EXTRA_FILES+=("$REL_PATH")
        fi
    done < <(find "$TARGET_DIR" -name "*.md" -type f -print0)
    
    # Warn about extra files
    if [[ ${#EXTRA_FILES[@]} -gt 0 ]]; then
        echo -e "{{ YELLOW }}⚠️  Found files in ~/.claude/commands/ not in this project:{{ CLEAR }}"
        for file in "${EXTRA_FILES[@]}"; do
            echo "  - $file"
        done
        echo -e "{{ YELLOW }}These files were NOT deleted.{{ CLEAR }}"
    fi
    
    # Count synced files
    COUNT=$(find "$SOURCE_DIR" -name "*.md" | wc -l)
    echo -e "\n{{ GREEN }}✅ Synced $COUNT Claude command files{{ CLEAR }}"
