{ ... }:
{
  programs.wezterm.enable = true;
  programs.wezterm.extraConfig = ''
    local wezterm = require 'wezterm'
    local act = wezterm.action

    local config = {}

    config.font = wezterm.font 'PragmataPro Mono Liga'
    config.font_size = 14.0

    config.color_scheme = 'nordfox'
    config.window_decorations = 'RESIZE'

    config.hide_tab_bar_if_only_one_tab = true

    config.keys = {
      {
        key = 'j',
        mods = 'CMD',
        action = act.Multiple {
          act.SendKey { key = 'a', mods='CTRL' },
          act.SendKey { key = 'T' },
        },
      },
      {
        key = 'g',
        mods = 'CMD',
        action = act.Multiple {
          act.SendKey { key = 'a', mods='CTRL' },
          act.SendKey { key = 'G' },
        },
      },
    }

    return config
  '';

}
