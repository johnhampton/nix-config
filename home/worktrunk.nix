{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    worktrunk
  ];

  xdg.configFile."worktrunk/config.toml".text = ''
    skip-shell-integration-prompt = true
    worktree-path = "{{ repo_path }}/../{{ branch | sanitize }}"

    [commit.generation]
    command = "CLAUDECODE= MAX_THINKING_TOKENS=0 claude -p --no-session-persistence --model=haiku --tools=''' --disable-slash-commands --setting-sources=''' --system-prompt='''"

    [projects."github.com/johnhampton/nix-config"]
    worktree-path = "~/Code/me/nix-config/{{ branch | sanitize }}"

    # auth-service-hs-client uses the .bare + per-branch worktree layout.
    # Symlink the local-only Claude config from the primary worktree so every
    # worktree shares one copy instead of drifting. Targets may not exist yet
    # (dangling links are harmless until the canonical files are created).
    [projects."github.com/topagentnetwork/auth-service-hs-client"]
    pre-start.link-local = "mkdir -p .claude && ln -sfn {{ primary_worktree_path }}/CLAUDE.local.md CLAUDE.local.md && ln -sfn {{ primary_worktree_path }}/.claude/settings.local.json .claude/settings.local.json"
  '';

  programs.zsh.initContent = lib.mkAfter ''
    # WorkTronk shell integration
    if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
  '';
}
