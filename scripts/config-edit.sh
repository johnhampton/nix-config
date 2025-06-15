#!/usr/bin/env bash
set -euo pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
CLEAR='\033[0m'

# Function to print colored output
print_error() {
    echo -e "${RED}$1${CLEAR}" >&2
}

print_success() {
    echo -e "${GREEN}$1${CLEAR}"
}

# Function to edit a config file
edit_config() {
    local FILE="$1"
    
    # Expand ~ to home directory
    FILE="${FILE/#\~/$HOME}"
    
    # Check if file exists
    if [[ ! -e "$FILE" ]]; then
        print_error "Error: File '$FILE' does not exist"
        exit 1
    fi
    
    # Check if it's a symlink (typical for Nix-managed files)
    if [[ ! -L "$FILE" ]]; then
        print_error "Warning: '$FILE' is not a symlink (might not be Nix-managed)"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Check if backup already exists
    if [[ -e "$FILE.bak" ]]; then
        print_error "Error: Backup file '$FILE.bak' already exists"
        echo "Please restore or remove it first with:"
        echo "  just restore-config '$FILE'"
        exit 1
    fi
    
    # Create backup and make editable copy
    if [[ -L "$FILE" ]]; then
        # It's a symlink - save the symlink and copy its target
        TARGET=$(readlink "$FILE")
        mv "$FILE" "$FILE.bak"
        cp "$TARGET" "$FILE"
    else
        # Not a symlink - just move and copy
        mv "$FILE" "$FILE.bak"
        cp "$FILE.bak" "$FILE"
    fi
    
    print_success "Success! Created editable copy of '$FILE'"
    echo "Original saved as '$FILE.bak'"
    echo "Edit the file, then restore with:"
    echo "  just restore-config '$FILE'        # Keep changes"
    echo "  just restore-config '$FILE' --discard  # Discard changes"
}

# Function to restore a config file
restore_config() {
    local FILE="$1"
    local DISCARD=false
    
    # Parse additional arguments
    shift
    for arg in "$@"; do
        if [[ "$arg" == "--discard" ]]; then
            DISCARD=true
        fi
    done
    
    # Expand ~ to home directory
    FILE="${FILE/#\~/$HOME}"
    
    # Check if backup exists
    if [[ ! -e "$FILE.bak" ]]; then
        print_error "Error: No backup file '$FILE.bak' found"
        echo "Nothing to restore."
        exit 1
    fi
    
    # Save current file if not discarding
    if [[ -e "$FILE" ]] && [[ "$DISCARD" == "false" ]]; then
        TIMESTAMP=$(date +%Y%m%d-%H%M%S)
        SAVED_FILE="$FILE.edited-$TIMESTAMP"
        cp "$FILE" "$SAVED_FILE"
        print_success "Saved your changes to: $SAVED_FILE"
    fi
    
    # Remove current file and restore backup
    rm -f "$FILE"
    mv "$FILE.bak" "$FILE"
    
    if [[ "$DISCARD" == "true" ]]; then
        print_success "Restored original file (changes discarded)"
    else
        print_success "Restored original file"
    fi
}

# Main script logic
case "${1:-}" in
    edit)
        if [[ -z "${2:-}" ]]; then
            print_error "Error: No file specified"
            echo "Usage: $0 edit <file>"
            exit 1
        fi
        edit_config "$2"
        ;;
    restore)
        if [[ -z "${2:-}" ]]; then
            print_error "Error: No file specified"
            echo "Usage: $0 restore <file> [--discard]"
            exit 1
        fi
        shift
        restore_config "$@"
        ;;
    *)
        print_error "Error: Invalid command"
        echo "Usage:"
        echo "  $0 edit <file>              # Create editable copy"
        echo "  $0 restore <file> [--discard]  # Restore from backup"
        exit 1
        ;;
esac