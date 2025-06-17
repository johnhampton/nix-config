#!/bin/bash

set -euo pipefail

# Validation and help
if [ $# -eq 0 ]; then
    echo "Error: No repository specified"
    echo "Usage: $0 <owner/repo>"
    echo "Example: $0 topagentnetwork/admin-graphql-server"
    exit 1
fi

OWNER_REPO="$1"

# Validate format
if [[ ! "$OWNER_REPO" =~ ^[^/]+/[^/]+$ ]]; then
    echo "Error: Invalid repository format"
    echo "Expected format: owner/repo"
    echo "Example: topagentnetwork/admin-graphql-server"
    exit 1
fi

OWNER=$(echo "$OWNER_REPO" | cut -d'/' -f1)
REPO=$(echo "$OWNER_REPO" | cut -d'/' -f2)

# Check if directory already exists
if [ -d "$REPO" ]; then
    echo "Error: Directory '$REPO' already exists"
    exit 1
fi

mkdir "$REPO"

# Build clone command conditionally
if [ "$OWNER" = "topagentnetwork" ]; then
    git clone --bare -c remote.origin.fetch="+refs/heads/*:refs/remotes/origin/*" -c core.logallrefupdates=true -c user.email=john@topagentnetwork.com "https://github.com/$OWNER_REPO.git" "$REPO/.bare"
else
    git clone --bare -c remote.origin.fetch="+refs/heads/*:refs/remotes/origin/*" -c core.logallrefupdates=true "https://github.com/$OWNER_REPO.git" "$REPO/.bare"
fi

echo "gitdir: ./.bare" > "$REPO/.git"
mkdir "$REPO/.shared"
git --git-dir="$REPO/.bare" fetch

# Set upstream for all branches
for branch in $(git --git-dir="$REPO/.bare" branch -r --format='%(refname:short)' | grep '^origin/' | sed 's/origin\///'); do
    git --git-dir="$REPO/.bare" branch -u "origin/$branch" "$branch"
done

# Create worktree for HEAD branch
HEAD_BRANCH=$(git --git-dir="$REPO/.bare" symbolic-ref HEAD | sed 's|refs/heads/||')
git --git-dir="$REPO/.bare" worktree add "$REPO/$HEAD_BRANCH" "$HEAD_BRANCH"

echo "Successfully set up repository: $REPO"
echo "Shared directory created at: $REPO/.shared"
echo "Main worktree created at: $REPO/$HEAD_BRANCH"
