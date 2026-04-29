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
  '';

  programs.zsh.initContent = lib.mkAfter ''
    # WorkTronk shell integration
    if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
  '';
}
