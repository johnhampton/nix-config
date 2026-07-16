{ lib, ... }:
{
  # Use Homebrew's WezTerm instead of Nix package
  # Copy the complete config file
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

  # No colors/ files needed: Catppuccin Mocha is a built-in WezTerm scheme.

  # Shell completion - source Homebrew's WezTerm shell completion if it exists
  programs.bash.initExtra = lib.mkAfter ''
    # WezTerm shell integration from Homebrew
    if [[ -f "/Applications/WezTerm.app/Contents/Resources/wezterm.sh" ]]; then
      source "/Applications/WezTerm.app/Contents/Resources/wezterm.sh"
    fi
    
    # WezTerm shell completion from Homebrew
    if [[ -f "/Applications/WezTerm.app/Contents/Resources/shell-completion/bash" ]]; then
      source "/Applications/WezTerm.app/Contents/Resources/shell-completion/bash"
    fi
  '';

  programs.zsh.initContent = lib.mkAfter ''
    # WezTerm shell integration from Homebrew
    if [[ -f "/Applications/WezTerm.app/Contents/Resources/wezterm.sh" ]]; then
      source "/Applications/WezTerm.app/Contents/Resources/wezterm.sh"
    fi
    
    # WezTerm shell completion from Homebrew
    if [[ -f "/Applications/WezTerm.app/Contents/Resources/shell-completion/zsh" ]]; then
      source "/Applications/WezTerm.app/Contents/Resources/shell-completion/zsh"
    fi
  '';
}
