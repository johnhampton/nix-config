#!/usr/bin/env bash

# Script to create symbolic links to everything in ../.shared
# Special handling: .claude directory contents are symlinked, not the directory itself

set -euo pipefail

SHARED_DIR="../.shared"
CURRENT_DIR="."

# Check if shared directory exists
if [ ! -d "$SHARED_DIR" ]; then
    echo "Error: $SHARED_DIR directory not found"
    exit 1
fi

# Function to create symlink with proper handling
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Remove existing symlink or file if it exists
    if [ -L "$target" ] || [ -e "$target" ]; then
        echo "Removing existing: $target"
        rm -rf "$target"
    fi
    
    # Create symlink
    ln -s "$source" "$target"
    echo "Linked: $source -> $target"
}

# Process each item in the shared directory (including hidden files)
for item in "$SHARED_DIR"/* "$SHARED_DIR"/.[!.]*; do
    # Skip if no files match the glob
    [ -e "$item" ] || continue
    
    basename_item=$(basename "$item")
    
    if [ "$basename_item" = ".claude" ] && [ -d "$item" ]; then
        # Special handling for .claude directory
        echo "Processing .claude directory..."
        
        # Create .claude directory if it doesn't exist
        mkdir -p "$CURRENT_DIR/.claude"
        
        # Symlink each file/directory inside .claude (including hidden)
        for claude_item in "$item"/* "$item"/.[!.]*; do
            [ -e "$claude_item" ] || continue
            claude_basename=$(basename "$claude_item")
            create_symlink "../../.shared/.claude/$claude_basename" "$CURRENT_DIR/.claude/$claude_basename"
        done
    else
        # Regular symlink for everything else
        create_symlink "../.shared/$basename_item" "$CURRENT_DIR/$basename_item"
    fi
done

echo "Done creating symbolic links!"