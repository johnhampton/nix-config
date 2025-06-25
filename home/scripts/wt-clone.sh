#!/bin/bash

set -euo pipefail

# Parse command-line arguments
WORK_EMAIL=""
REPOSITORY=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --work-email)
            WORK_EMAIL="john@topagentnetwork.com"
            shift
            ;;
        *)
            if [ -z "$REPOSITORY" ]; then
                REPOSITORY="$1"
            else
                SCRIPT_NAME=$(basename "$0")
                echo "Error: Too many arguments"
                echo "Usage: $SCRIPT_NAME [--work-email] <repository>"
                exit 1
            fi
            shift
            ;;
    esac
done

# Validation and help
if [ -z "$REPOSITORY" ]; then
    SCRIPT_NAME=$(basename "$0")
    echo "Error: No repository specified"
    echo "Usage: $SCRIPT_NAME [--work-email] <repository>"
    echo ""
    echo "Arguments:"
    echo "  repository    Can be one of:"
    echo "                - owner/repo (defaults to GitHub)"
    echo "                - Full clone URL (e.g., https://gitlab.com/owner/repo.git)"
    echo ""
    echo "Options:"
    echo "  --work-email  Use work email (john@topagentnetwork.com) for commits"
    echo ""
    echo "Examples:"
    echo "  $SCRIPT_NAME topagentnetwork/admin-graphql-server"
    echo "  $SCRIPT_NAME --work-email gitlab/project"
    echo "  $SCRIPT_NAME https://gitlab.com/owner/repo.git"
    exit 1
fi

OWNER_REPO="$REPOSITORY"

# Detect URL type and extract components
CLONE_URL=""
REPO_NAME=""

if [[ "$OWNER_REPO" =~ ^https?:// ]]; then
    # Full URL provided
    CLONE_URL="$OWNER_REPO"
    
    # Extract repo name from URL (remove .git suffix if present)
    REPO_NAME=$(basename "$CLONE_URL" .git)
    
    # Validate URL format
    if [[ ! "$CLONE_URL" =~ \.(git|[^/]+)$ ]]; then
        echo "Error: Invalid URL format"
        echo "Expected URL ending in .git or repository name"
        echo "Example: https://gitlab.com/owner/repo.git"
        exit 1
    fi
elif [[ "$OWNER_REPO" =~ ^[^/]+/[^/]+$ ]]; then
    # owner/repo format - default to GitHub
    OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
    REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)
    REPO_NAME="$REPO"
    CLONE_URL="https://github.com/$OWNER_REPO.git"
else
    echo "Error: Invalid repository format"
    echo "Expected format: owner/repo or full clone URL"
    echo "Examples:"
    echo "  owner/repo"
    echo "  https://gitlab.com/owner/repo.git"
    exit 1
fi

# Check if directory already exists
if [ -d "$REPO_NAME" ]; then
    echo "Error: Directory '$REPO_NAME' already exists"
    exit 1
fi

mkdir "$REPO_NAME"

# Build clone command conditionally
if [ -n "$WORK_EMAIL" ]; then
    git clone --bare -c remote.origin.fetch="+refs/heads/*:refs/remotes/origin/*" -c core.logallrefupdates=true -c user.email="$WORK_EMAIL" "$CLONE_URL" "$REPO_NAME/.bare"
else
    git clone --bare -c remote.origin.fetch="+refs/heads/*:refs/remotes/origin/*" -c core.logallrefupdates=true "$CLONE_URL" "$REPO_NAME/.bare"
fi

echo "gitdir: ./.bare" > "$REPO_NAME/.git"
mkdir "$REPO_NAME/.shared"
git --git-dir="$REPO_NAME/.bare" fetch

# Set upstream for all branches
for branch in $(git --git-dir="$REPO_NAME/.bare" branch -r --format='%(refname:short)' | grep '^origin/' | sed 's/origin\///'); do
    git --git-dir="$REPO_NAME/.bare" branch -u "origin/$branch" "$branch"
done

# Create worktree for HEAD branch
HEAD_BRANCH=$(git --git-dir="$REPO_NAME/.bare" symbolic-ref HEAD | sed 's|refs/heads/||')
git --git-dir="$REPO_NAME/.bare" worktree add "$REPO_NAME/$HEAD_BRANCH" "$HEAD_BRANCH"

echo "Successfully set up repository: $REPO_NAME"
echo "Shared directory created at: $REPO_NAME/.shared"
echo "Main worktree created at: $REPO_NAME/$HEAD_BRANCH"
