{ pkgs, lib, ... }:
{
  # Use Homebrew's WezTerm instead of Nix package
  # Copy the complete config file
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;

  # Copy color schemes from vim plugin
  xdg.configFile."wezterm/colors/onenord.toml".source =
    "${pkgs.vimPlugins.onenord-nvim.src}/extras/wezterm/onenord.toml";
  xdg.configFile."wezterm/colors/onenord_light.toml".source =
    "${pkgs.vimPlugins.onenord-nvim.src}/extras/wezterm/onenord_light.toml";

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
