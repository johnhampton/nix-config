{ ... }:
{
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = ''
    local wezterm = require 'wezterm'
    local config = {}

    config.font = wezterm.font 'PragmataPro Liga'
    config.font_size = 14.0

    config.color_scheme = 'nordfox'

    config.hide_tab_bar_if_only_one_tab = true

    return config
  '';

}
