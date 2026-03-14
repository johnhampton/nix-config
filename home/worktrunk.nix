{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    worktrunk
  ];

  xdg.configFile."worktrunk/config.toml".text = ''
    skip-shell-integration-prompt = true
    worktree-path = "{{ repo_path }}/../{{ branch | sanitize }}"
  '';

  programs.zsh.initContent = lib.mkAfter ''
    # WorkTronk shell integration
    if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
  '';
}
